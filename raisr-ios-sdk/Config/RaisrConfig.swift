//
//  RaisrConfig.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation

public class RaisrConfig {
    
    private var spaceId: String;
    private var messagingSecret: String;
    
    public init(spaceId: String, secret: String) {
        self.spaceId = spaceId;
        self.messagingSecret = secret;
    }
    
    public func getSpaceId() -> String {
        return self.spaceId;
    }
    
    public func getMessagingSecret() -> String {
        return self.messagingSecret;
    }
    
    
    public class Builder {
        
        private var spaceId: String?;
        private var messagingSecret: String?;
        
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
        
        public func build() -> RaisrConfig {
            return RaisrConfig(spaceId: self.spaceId!, secret: self.messagingSecret!);
        }
        
    }
    
}
