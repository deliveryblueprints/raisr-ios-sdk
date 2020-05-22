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

#import "CMPAPIConfiguration.h"

#import "CMPComapiConfigBuilder.h"
#import "CMPLogger.h"
#import "CMPLogConfig.h"

@implementation CMPComapiConfigBuilder

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _config = [CMPComapiConfig new];
    }
    
    return self;
}

- (CMPComapiConfig *)build {
    [self fillEmpty];
    
    return _config;
}

- (void)fillEmpty {
    if (!_config.id)
        logWithLevel(CMPLogLevelWarning, @"Config: apiSpaceID not set, SDK will not start without it.");
    if (!_config.authDelegate)
        logWithLevel(CMPLogLevelWarning, @"Config: authentication delegate not set, SDK will not start without it.");
    if (!_config.apiConfig)
        _config.apiConfig = CMPAPIConfiguration.production;
}

- (instancetype)setApiSpaceID:(NSString *)apiSpaceID {
    _config.id = apiSpaceID;
    return self;
}

- (instancetype)setApiConfig:(CMPAPIConfiguration *)apiConfig {
    _config.apiConfig = apiConfig;
    return self;
}

- (instancetype)setLogLevel:(CMPLogLevel)logLevel {
    _config.logLevel = logLevel;
    [CMPLogConfig setLogLevel:logLevel];
    [[CMPLogger shared] resetDestinations];
    return self;
}

- (instancetype)setAuthDelegate:(id<CMPAuthenticationDelegate>)authDelegate {
    _config.authDelegate = authDelegate;
    return self;
}


@end
