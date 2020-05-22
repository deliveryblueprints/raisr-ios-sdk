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

#import "CMPRequestPerformer.h"

#import "CMPURLResult.h"
#import "NSData+CMPUtility.h"
#import "CMPConstants.h"
#import "CMPLogger.h"

@implementation CMPRequestPerformer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return self;
}

- (void)performRequest:(NSURLRequest *)request completion:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completion {
    logWithLevel(CMPLogLevelVerbose, @"WILL PERFORM REQUEST:", [request description], nil);
    
    if ([request.HTTPMethod isEqualToString:CMPHTTPMethodPOST] && request.HTTPBodyStream != nil) {
        NSData *data = [[NSData alloc] initWithInputStream:request.HTTPBodyStream];
        NSURLSessionTask *task = [self.session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            CMPURLResult *result = [[CMPURLResult alloc] initWithRequest:request data:data response:response error:error];
            logWithLevel(CMPLogLevelVerbose, @"UPLOAD TASK FINISHED", result, nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(data, response, error);
            });
        }];
        
        [task resume];
    } else {
        NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            CMPURLResult *result = [[CMPURLResult alloc] initWithRequest:request data:data response:response error:error];
            logWithLevel(CMPLogLevelVerbose, @"DID FINISH REQUEST", result, nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(data, response, error);
            });
        }];
        
        [task resume];
    }
}

@end
