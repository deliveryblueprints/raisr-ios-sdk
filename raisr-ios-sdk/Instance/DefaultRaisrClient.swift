//
//  MockRaisrInstance.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation
import CMPComapiFoundation
import JWT

@objcMembers public class DefaultRaisrClient: NSObject, RaisrClient {
    
    private var comConfig: ComapiConfig?;
    private var config: RaisrConfig;
    private var comClient: ComapiClient?;
    private var session: RaisrSession?;
    private var pushToken: String?;
    private var decodedJWT: DecodedUserJWT?;
    
    init(config: RaisrConfig) {
        self.config = config;
    }

    public func startSession(withEmail: String, withMobile: String, completion: @escaping (RaisrResult) -> Void) {
        self.startSession { (result) in
            if(result.isSuccessful()) {
                self.updateUser(attributes: ["email": withEmail, "phoneNumber": withMobile], completion: { (result) in
                    if(result.isSuccessful()) {
                        completion(RaisrResult.Success());
                    } else {
                        completion(RaisrResult.Error(error: result.getError()!))
                    }
                })
            } else {
                completion(RaisrResult.Error(error: result.getError()!))
            }
        }
    }

    
    public func startSession(completion: @escaping (_ result: RaisrResult) -> Void) {
    
        if(self.hasActiveSession()) {
            completion(RaisrResult.Success());
        } else {
            
            self.config.getAuthDelegate().authenticationChallenge(continueWithTokenAndUserId: { (token, userId) in
            
                do {
                    
                    self.decodedJWT = try DefaultRaisrSession.decodeJWT(token: token, userId: userId);
                    let comConfig = self.initialseDotDigital();
                    self.comClient = Comapi.initialise(with: comConfig);
                    
                    self.comClient!.services.session.startSession(completion: {
                        
                        self.session = DefaultRaisrSession(
                            userId: self.decodedJWT!.userId,
                            claims: self.decodedJWT!.claims,
                            profileId: self.comClient!.profileID!
                        );
                        
                        self.syncPushToken(completion: { (result) in
                            if(result.isSuccessful()) {
                                self.decodedJWT = nil;
                                completion(RaisrResult.Success());
                            } else {
                                completion(RaisrResult.Error(error: RaisrError.SessionInitialisationError))
                            }
                        })
                        
                    }) { (error) in
                        completion(RaisrResult.Error(error: RaisrError.SessionInitialisationError))
                    }

                } catch {
                    completion(RaisrResult.Error(error: RaisrError.SessionInitialisationError));
                }
        
            })
            
        }
        
    }
    
    public func updateUser(attributes: Dictionary<String, String>, completion: @escaping (RaisrResult) -> Void) {
        self.syncUserProfile(attributes: attributes, completion: completion);
    }
    
    public func endSession(completion: @escaping (_ result: RaisrResult) -> Void) {
        if(self.hasActiveSession()) {
            self.comClient?.services.session.endSession(completion: { (result) in
                if(result.error != nil) {
                    completion(RaisrResult.Error(error: result.error!));
                } else {
                    self.session = nil;
                    self.comClient = nil;
                    completion(RaisrResult.Success());
                }
            })
        } else {
            completion(RaisrResult.Success());
        }
    }
    
    public func hasActiveSession() -> Bool {
        return (
            self.session != nil &&
            self.comClient != nil
        );
    }
    
    public func updatePushToken(token: String, completion: @escaping (_ result: RaisrResult) -> Void) {
        self.pushToken = token;
        self.syncPushToken(completion: completion);
    }
    
    private func initialseDotDigital() -> ComapiConfig {
        return ComapiConfig.builder()
            .setApiSpaceID(self.config.getSpaceId())
            .setAuthDelegate(self)
            .build();
    }

    
    private func syncPushToken(completion: @escaping (_ result: RaisrResult) -> Void) -> Void {

        if(self.pushToken != nil && self.hasActiveSession()) {
            self.comClient?.set(pushToken: self.pushToken!, completion: { (success, error) in
                if(success && error == nil) {
                    completion(RaisrResult.Success());
                } else {
                    completion(RaisrResult.Error(error: error!))
                }
            })
        } else {
            completion(RaisrResult.Success());
        }
    
    }

    private func syncUserProfile(attributes: Dictionary<String, String>, completion: @escaping (RaisrResult) -> Void) {
        
        if(self.hasActiveSession()) {
            
            self.comClient!.services.profile.getProfile(profileID: self.session!.profileId) { (result) in
                if(result.error == nil) {
                    self.comClient!.services.profile.updateProfile(profileID: self.session!.profileId, attributes: attributes, eTag: result.eTag, completion: { (result) in
                        
                        if(result.error != nil) {
                            completion(RaisrResult.Error(error: result.error!))
                        } else {
                            completion(RaisrResult.Success())
                        }
                        
                    })
                } else {
                    completion(RaisrResult.Error(error: result.error!))
                }
            }
            
        }
        
    }
        
}

extension DefaultRaisrClient: AuthenticationDelegate {
    public func client(_ client: ComapiClient, didReceive challenge: AuthenticationChallenge, completion continueWithToken: @escaping (String?) -> Void) {

        
        var request = URLRequest(url: URL(string: "https://mclapi.raisrdelivery.co.uk/auth/messaging")!);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        request.httpMethod = "POST";
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "userId": self.decodedJWT!.userId,
            "nonce": challenge.nonce
        ], options: [])
        
        let configuration = URLSessionConfiguration.default;
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main);
        
        let requestTask = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, String>;
                continueWithToken(jsonResponse["authToken"])
            } catch {
                continueWithToken(nil);
            }
            
        })
        
        requestTask.resume();
        
    }
}

extension DefaultRaisrClient: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }
    
}
