//
//  DecodedUserJWT.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 29/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation

struct DecodedUserJWT {
    public var userId: String;
    public var claims: Dictionary<AnyHashable, Any>;
}
