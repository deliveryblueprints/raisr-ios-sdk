//
//  RaisrAuthDelegate.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 29/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation

@objc public protocol RaisrAuthenticationDelegate {
    
    func authenticationChallenge(continueWithTokenAndUserId: @escaping (_ token: String, _ userId: String?) -> Void) -> Void
    
}
