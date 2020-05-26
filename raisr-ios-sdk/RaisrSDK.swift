//
//  RaisrSDK.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation
import CMPComapiFoundation

public class RaisrSDK {
    
    public class func initialise(config: RaisrConfig) -> RaisrInstance {
        let dotDigitalConfig = RaisrSDK.initialseDotDigital(config: config)
        return MockRaisrInstance(dotDigitalConfig: dotDigitalConfig, config: config);
    }
    
    private class func initialseDotDigital(config: RaisrConfig) -> ComapiConfig {
        return ComapiConfig.builder()
            .setApiSpaceID(config.getSpaceId())
            .setAuthDelegate(DotDigitalAuthenticator(secret: config.getMessagingSecret()))
            .build();
    }
    
}
