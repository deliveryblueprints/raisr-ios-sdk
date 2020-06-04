//
//  DefaultRaisrSession.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 29/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation
import JWTDecode

@objcMembers public class DefaultRaisrSession : NSObject, RaisrSession {

    public var userId: String
    public var claims: Dictionary<AnyHashable, Any>;
    public var profileId: String

    
    init(userId: String, claims: Dictionary<AnyHashable, Any>, profileId: String) {
        self.userId = userId;
        self.claims = claims;
        self.profileId = profileId;
    }
    
    class func decodeJWT(token: String, userId: String?) throws -> DecodedUserJWT {
        let jwt = try decode(jwt: token)
        if(jwt.body["sub"] == nil) {
            throw RaisrError.BadToken;
        }
        
        let decodedUserId = (userId == nil) ? jwt.body["sub"] as! String : userId!;
        return DecodedUserJWT(userId: decodedUserId, claims: jwt.body);
    }
    
}
