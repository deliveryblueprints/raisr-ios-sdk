//
//  RaisrInstance.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation

@objc public protocol RaisrClient {
    
    func startSession(completion: @escaping (_ result: RaisrResult) -> Void) -> Void
    
    func startSession(withEmail: String, withMobile: String, completion: @escaping (_ result: RaisrResult) -> Void) -> Void
    
    func endSession(completion: @escaping (_ result: RaisrResult) -> Void) -> Void
    
    func updateUser(attributes: Dictionary<String, String>, completion: @escaping (_ result: RaisrResult) -> Void) -> Void
    
    func hasActiveSession() -> Bool
    
    func updatePushToken(token: String, completion: @escaping(_ result: RaisrResult) -> Void) -> Void
    
}
