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
    
    init(secret: String) {
        self.secret = secret;
    }
    
    public func client(_ client: ComapiClient, didReceive challenge: AuthenticationChallenge, completion continueWithToken: @escaping (String?) -> Void) {
        
        let now = Date();
        let exp = Calendar.current.date(byAdding: .day, value: 30, to: now)!;
        
        let headers = ["typ": "JWT"];
        let payload: [AnyHashable: Any] = [
            "nonce" : challenge.nonce,
            "sub" : "test",
            "iss" : "https://api.comapi.com/defaultauth",
            "aud" : "https://api.comapi.com",
            "iat" : Double(now.timeIntervalSince1970),
            "exp" : Double(exp.timeIntervalSince1970)
        ];
        
        let algorithm = JWTAlgorithmFactory.algorithm(byName: "HS256")
        let token = JWTBuilder.encodePayload(payload).headers(headers)?.secret(secret)?.algorithm(algorithm)?.encode;
        
        continueWithToken(token);
        
    }

    
}
