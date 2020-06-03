//
//  RaisrSDK.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation
import CMPComapiFoundation

@objcMembers public class RaisrSDK: NSObject {
    
    public class func initialise(config: RaisrConfig) throws -> DefaultRaisrClient {
        return DefaultRaisrClient(config: config);
    }
    
}
