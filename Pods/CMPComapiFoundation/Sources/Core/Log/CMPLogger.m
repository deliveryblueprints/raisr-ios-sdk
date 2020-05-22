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

#import "CMPLogger.h"
#import "CMPLog.h"
#import "CMPLoggingDestination.h"
#import "CMPXcodeConsoleDestination.h"
#import "CMPFileDestination.h"
#import "CMPConstants.h"
#import "NSDateFormatter+CMPUtility.h"

void logWithLevel(CMPLogLevel logLevel, id params, ...) {
    NSMutableArray *arguments = [NSMutableArray new];
    id eachObject;
    va_list argumentList;
    if (params)
    {
        [arguments addObject: params];
        va_start(argumentList, params);
        while ((eachObject = va_arg(argumentList, id)))
        {
            [arguments addObject: eachObject];
        }
        va_end(argumentList);
    }
    
    switch (logLevel) {
        case CMPLogLevelInfo:
            [[CMPLogger shared] info:arguments];
            break;
        case CMPLogLevelVerbose:
            [[CMPLogger shared] verbose:arguments];
            break;
        case CMPLogLevelError:
            [[CMPLogger shared] error:arguments];
            break;
        case CMPLogLevelDebug:
            [[CMPLogger shared] debug:arguments];
            break;
        case CMPLogLevelWarning:
            [[CMPLogger shared] warning:arguments];
            break;
    }
}

@interface CMPLogger ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray<id<CMPLoggingDestination>> * loggingDestinations;

@end

@implementation CMPLogger

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.queue = dispatch_queue_create([CMPQueueNameConsole UTF8String], DISPATCH_QUEUE_SERIAL);
        self.dateFormatter = [NSDateFormatter iso8061Formatter];
        self.loggingDestinations = [NSMutableArray new];
        
        [self.loggingDestinations addObject:[CMPLog fileDestination]];
        [self.loggingDestinations addObject:[CMPLog consoleDestination]];
    }
    
    return self;
}

+ (CMPLogger *)shared {
    static CMPLogger *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[CMPLogger alloc] init];
    });
    return instance;
}

- (void)addDestination:(id<CMPLoggingDestination>)destination {
    dispatch_sync(self.queue, ^{
        [self.loggingDestinations addObject:destination];
    });
}

- (void)resetDestinations {
    dispatch_sync(self.queue, ^{
        [self.loggingDestinations removeAllObjects];
        
        [self.loggingDestinations addObject:[CMPLog fileDestination]];
        [self.loggingDestinations addObject:[CMPLog consoleDestination]];
    });
}

- (void)logItems:(NSArray<id> *)items level:(CMPLogLevel)level {
    NSDate *date = [NSDate date];
    dispatch_sync(self.queue, ^{
        [self.loggingDestinations enumerateObjectsUsingBlock:^(id<CMPLoggingDestination> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj logItems:items level:level date:date];
        }];
    });
}

- (nullable NSData *)getFileLogs {
    for (id<CMPLoggingDestination> destination in self.loggingDestinations) {
        if ([destination isKindOfClass:CMPFileDestination.class]) {
            return [(CMPFileDestination *)destination getFileLogs];
        }
    }
    
    return nil;
}

- (void)debug:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelDebug];
}

- (void)error:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelError];
}

- (void)info:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelInfo];
}

- (void)verbose:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelVerbose];
}

- (void)warning:(NSArray<id> *)params {
    [self logItems:params level:CMPLogLevelWarning];
}

@end
