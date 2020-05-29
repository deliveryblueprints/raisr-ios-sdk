//
//  RaisrError.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 29/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation

public enum RaisrError: Error {
    case InvalidConfig(String);
    case BadToken;
    case SessionInitialisationError
}
