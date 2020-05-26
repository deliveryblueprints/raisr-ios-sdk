//
//  RaisrInstance.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 22/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation

public protocol RaisrInstance {
    
    func authenticate(username: String, password: String) -> Void
    
}
