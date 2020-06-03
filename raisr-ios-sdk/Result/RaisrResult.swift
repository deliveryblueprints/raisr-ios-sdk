//
//  RaisrResult.swift
//  raisr-ios-sdk
//
//  Created by Nicky Thorne on 29/05/2020.
//  Copyright © 2020 Nicky Thorne. All rights reserved.
//

import Foundation

@objcMembers public class RaisrResult: NSObject {
    
    private let error: Error?;
    private let success: Bool;
    
    init(error: Error?) {
        self.error = error;
        self.success = (error == nil);
    }
    
    public func isSuccessful() -> Bool {
        return self.success == true;
    }
    
    public func getError() -> Error? {
        return self.error;
    }
    
    public class func Error(error: Error) -> RaisrResult {
        return RaisrResult(error: error);
    }
    
    public class func Success() -> RaisrResult {
        return RaisrResult(error: nil);
    }
    
}
