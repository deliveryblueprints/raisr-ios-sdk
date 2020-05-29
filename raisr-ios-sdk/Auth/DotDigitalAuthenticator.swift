//
//  DotDigitalAuthenticator.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation
import JWT
import CMPComapiFoundation

public class DotDigitalAuthenticator: NSObject, AuthenticationDelegate {
    
    private var secret: String;
    private var userId: String;
    
    init(secret: String, userId: String) {
        self.secret = secret;
        self.userId = userId;
    }
    
    public func client(_ client: ComapiClient, didReceive challenge: AuthenticationChallenge, completion continueWithToken: @escaping (String?) -> Void) {
        
       
        
    }

    
}
