//
//  RaisrConfig.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation

public class RaisrConfig {
    
    private var listener: PushMessageListener;
    private var spaceId: String;
    private var messagingSecret: String;
    
    init(listener: PushMessageListener, spaceId: String, secret: String) {
        self.listener = listener;
        self.spaceId = spaceId;
        self.messagingSecret = secret;
    }
    
    public func getPushMessageListener() -> PushMessageListener {
        return self.listener;
    }
    
    public func getSpaceId() -> String {
        return self.spaceId;
    }
    
    public func getMessagingSecret() -> String {
        return self.messagingSecret;
    }
    
    
    public class Builder {
        
        private var listener: PushMessageListener?;
        private var spaceId: String?;
        private var messagingSecret: String?;
        
        init() {
            
        }
        
        public func pushMessageListener(listener: PushMessageListener) -> Builder {
            self.listener = listener;
            return self;
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
            return RaisrConfig(listener: self.listener!, spaceId: self.spaceId!, secret: self.messagingSecret!);
        }
        
    }
    
}
