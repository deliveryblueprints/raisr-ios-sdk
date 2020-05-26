//
//  MockRaisrInstance.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation
import CMPComapiFoundation

public class MockRaisrInstance: RaisrInstance {
    
    private var dotDigitalConfig: ComapiConfig;
    private var config: RaisrConfig;
    private var client: ComapiClient?;
    
    init(dotDigitalConfig: ComapiConfig, config: RaisrConfig) {
        self.dotDigitalConfig = dotDigitalConfig;
        self.config = config;
        self.client = Comapi.initialiseSharedInstance(with: self.dotDigitalConfig);
    }
    
    
    public func authenticate(username: String, password: String) {
        
        if(self.client!.isSessionSuccessfullyCreated == true) {
            self.updateDotDigitalEmail(username: username)
        } else {
    
            self.client!.services.session.startSession(completion: {
                self.updateDotDigitalEmail(username: username);
            }, failure: { (error) in
            
            })
            
        }
        
    }
    
    private func updateDotDigitalEmail(username: String) -> Void {
        self.client!.services.profile.getProfile(profileID: self.client!.profileID!, completion: { (result) in
            
            if(result.error != nil) {
                
                
                
            } else {
                
                self.client!.services.profile.patchProfile(profileID: self.client!.profileID!, attributes: ["email": username], eTag: nil, completion: { (result) in
                    
                    if(result.error != nil) {
                        
                    } else {
                        
                    }
                    
                    
                })
            }
            
        })
    
    }
    
    
}
