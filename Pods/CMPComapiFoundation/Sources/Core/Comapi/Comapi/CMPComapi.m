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

#import "CMPComapi.h"

#import "CMPComapiClient.h"
#import "CMPComapiConfig.h"
#import "CMPLogger.h"
#import "CMPRequestPerforming.h"

@interface CMPComapi ()

@end

@interface CMPComapiClient ()

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration;
- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate apiConfiguration:(CMPAPIConfiguration *)configuration requestPerformer:(id<CMPRequestPerforming>)requestPerformer;

@end

@implementation CMPComapi

static CMPComapiClient *_shared = nil;

+ (void)setShared:(CMPComapiClient *)shared {
    _shared = shared;
}

+ (CMPComapiClient *)shared {
    CMPComapiClient *client = _shared;
    if (!client) {
        return nil;
    }
    return client;
}

+ (CMPComapiClient *)initialiseWithConfig:(CMPComapiConfig *)config {
    CMPComapiClient *instance = [[CMPComapiClient alloc] initWithApiSpaceID:config.id authenticationDelegate:config.authDelegate apiConfiguration:config.apiConfig];
    
    return instance;
}

+ (CMPComapiClient *)initialiseSharedInstanceWithConfig:(CMPComapiConfig *)config {
    if (_shared) {
        logWithLevel(CMPLogLevelError, @"Client already initialised, returnig current client...", nil);
        return _shared;
    }
    
    [self setShared:[[CMPComapiClient alloc] initWithApiSpaceID:config.id authenticationDelegate:config.authDelegate apiConfiguration:config.apiConfig]];
    
    return _shared;
}


@end
