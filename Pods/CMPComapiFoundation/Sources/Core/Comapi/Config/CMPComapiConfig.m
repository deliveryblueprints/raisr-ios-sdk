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

#import "CMPComapiConfig.h"

#import "CMPAPIConfiguration.h"
#import "CMPComapiConfigBuilder.h"
#import "CMPLogConfig.h"
#import "CMPLogger.h"
#import "CMPLogLevel.h"

@interface CMPComapiConfig ()

@end

@implementation CMPComapiConfig

+ (CMPComapiConfigBuilder *)builder {
    return [CMPComapiConfigBuilder new];
}

- (void)setLogLevel:(CMPLogLevel)logLevel {
    _logLevel = logLevel;
    [CMPLogConfig setLogLevel:self.logLevel];
    [[CMPLogger shared] resetDestinations];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    CMPComapiConfig *c = [[CMPComapiConfig alloc] init];
    
    c.id = self.id;
    c.authDelegate = self.authDelegate;
    c.apiConfig = self.apiConfig;
    c.logLevel = self.logLevel;
    
    return c;
}

@end
