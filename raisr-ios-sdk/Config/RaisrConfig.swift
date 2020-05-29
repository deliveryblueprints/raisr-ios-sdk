//
//  RaisrConfig.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation

@objc public class RaisrConfig: NSObject {
    
    private var spaceId: String;
    private var messagingSecret: String;
    private var authDelegate: RaisrAuthenticationDelegate;
    
    public init(spaceId: String, secret: String, authDelegate: RaisrAuthenticationDelegate) {
        self.spaceId = spaceId;
        self.messagingSecret = secret;
        self.authDelegate = authDelegate;
    }
    
    public func getSpaceId() -> String {
        return self.spaceId;
    }
    
    public func getMessagingSecret() -> String {
        return self.messagingSecret;
    }
    
    public func getAuthDelegate() -> RaisrAuthenticationDelegate {
        return self.authDelegate;
    }
    
    
    public class Builder {
        
        private var spaceId: String?;
        private var messagingSecret: String?;
        private var authDelegate: RaisrAuthenticationDelegate?;
        
        public init() {
            
        }
    
        public func spaceId(spaceId: String) -> Builder {
            self.spaceId = spaceId;
            return self;
        }
        
        public func messagingSecret(messagingSecret: String) -> Builder {
            self.messagingSecret = messagingSecret
            return self;
        }
        
        public func authDelegate(authDelegate: RaisrAuthenticationDelegate) -> Builder {
            self.authDelegate = authDelegate;
            return self;
        }
        
        public func build() throws -> RaisrConfig {
            
            if(self.spaceId == nil || self.messagingSecret == nil || self.authDelegate == nil) {
                throw RaisrError.InvalidConfig("Invalid Raisr configuration. SpaceID, Messaging Secret and Auth Delegate are required");
            }
            
            return RaisrConfig(spaceId: self.spaceId!, secret: self.messagingSecret!, authDelegate: self.authDelegate!);
        }
        
    }
    
}
