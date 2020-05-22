//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMPAuthorizeSessionBody.h"

#import "CMPConstants.h"

#import <UIKit/UIKit.h>

@implementation CMPAuthorizeSessionBody

- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken {
    self = [super init];
    
    if (self) {
        self.authenticationID = authenticationID;
        self.authenticationToken = authenticationToken;
        self.deviceID = [[UIDevice currentDevice] model];
        self.platform = CMPSDKInfoPlatform;
        self.platformVersion = [[UIDevice currentDevice] systemVersion];
        self.sdkType = CMPSDKInfoType;
        self.sdkVersion = CMPSDKInfoVersion;
    }
    
    return self;
}

- (instancetype)initWithAuthenticationID:(NSString *)authenticationID authenticationToken:(NSString *)authenticationToken deviceID:(NSString *)deviceID platform:(NSString *)platform platformVersion:(NSString *)platformVersion sdkType:(NSString *)sdkType sdkVersion:(NSString *)sdkVersion {
    self = [super init];
    
    if (self) {
        self.authenticationID = authenticationID;
        self.authenticationToken = authenticationToken;
        self.deviceID = deviceID;
        self.platform = platform;
        self.platformVersion = platformVersion;
        self.sdkType = sdkType;
        self.sdkVersion = sdkVersion;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.authenticationID forKey:@"authenticationId"];
    [dict setValue:self.authenticationToken forKey:@"authenticationToken"];
    [dict setValue:self.deviceID forKey:@"deviceId"];
    [dict setValue:self.platform forKey:@"platform"];
    [dict setValue:self.platformVersion forKey:@"platformVersion"];
    [dict setValue:self.sdkType forKey:@"sdkType"];
    [dict setValue:self.sdkVersion forKey:@"sdkVersion"];
    
    return dict;
}

- (NSData *)encode {
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    
    return json;
}

@end
