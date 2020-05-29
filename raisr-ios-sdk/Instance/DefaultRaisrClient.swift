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

@objc class DefaultRaisrClient: NSObject, RaisrClient {
    
    private var comConfig: ComapiConfig?;
    private var config: RaisrConfig;
    private var comClient: ComapiClient?;
    private var session: RaisrSession?;
    private var pushToken: String?;
    private var decodedJWT: DecodedUserJWT?;
    
    init(config: RaisrConfig) {
        self.config = config;
    }

    func startSession(withEmail: String, withMobile: String, completion: @escaping (RaisrResult) -> Void) {
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

    
    func startSession(completion: @escaping (_ result: RaisrResult) -> Void) {
    
        if(self.hasActiveSession()) {
            completion(RaisrResult.Success());
        } else {
            
            self.config.getAuthDelegate().authenticationChallenge(continueWithToken: { (token) in
            
                do {
                    
                    self.decodedJWT = try DefaultRaisrSession.decodeJWT(token: token);
                    let comConfig = self.initialseDotDigital(userId: self.decodedJWT!.userId);
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
    
    func updateUser(attributes: Dictionary<String, String>, completion: @escaping (RaisrResult) -> Void) {
        self.syncUserProfile(attributes: attributes, completion: completion);
    }
    
    func endSession(completion: @escaping (_ result: RaisrResult) -> Void) {
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
    
    func hasActiveSession() -> Bool {
        return (
            self.session != nil &&
            self.comClient != nil
        );
    }
    
    public func updatePushToken(token: String, completion: @escaping (_ result: RaisrResult) -> Void) {
        self.pushToken = token;
        self.syncPushToken(completion: completion);
    }
    
    private func initialseDotDigital(userId: String) -> ComapiConfig {
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
    func client(_ client: ComapiClient, didReceive challenge: AuthenticationChallenge, completion continueWithToken: @escaping (String?) -> Void) {

        let now = Date();
        let exp = Calendar.current.date(byAdding: .day, value: 30, to: now)!;
        
        let headers = ["typ": "JWT"];
        let payload: [AnyHashable: Any] = [
            "nonce" : challenge.nonce,
            "sub" : self.decodedJWT!.userId,
            "iss" : "https://api.comapi.com/defaultauth",
            "aud" : "https://api.comapi.com",
            "iat" : Double(now.timeIntervalSince1970),
            "exp" : Double(exp.timeIntervalSince1970)
        ];
        
        let algorithm = JWTAlgorithmFactory.algorithm(byName: "HS256")
        let secret = self.config.getMessagingSecret();
        let jwt = JWT.encodePayload(payload, withSecret: secret, algorithm: algorithm);
        
        continueWithToken(jwt);
        
    }
}
