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

#import "CMPRequestTemplate.h"
#import "CMPHTTPHeader.h"
#import "CMPRequestPerformer.h"
#import "CMPHTTPRequestTemplate.h"
#import "CMPHTTPHeader.h"
#import "CMPConstants.h"
#import "CMPErrors.h"
#import "NSURLResponse+CMPUtility.h"

@implementation CMPRequestTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID {
    self = [super init];
    
    if (self) {
        self.scheme = scheme;
        self.host = host;
        self.port = port;
        self.apiSpaceID = apiSpaceID;
    }
    
    return self;
}

- (NSURLComponents *)componentsFromURLTemplate:(id<CMPHTTPRequestTemplate>)template {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.host = self.host;
    components.scheme = self.scheme;
    components.port = @(self.port);
    components.path = [NSString stringWithFormat:@"/%@", [template.pathComponents componentsJoinedByString:@"/"]];

    if (template.query != nil && template.query.allKeys.count > 0) {
        NSMutableArray<NSURLQueryItem *> *items = [[NSMutableArray alloc] init];
        [template.query enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:key value:obj];
            [items addObject:item];
        }];
        components.queryItems = items;
    }

    return components;
}

- (NSURLRequest *)requestFromHTTPRequestTemplate:(id<CMPHTTPRequestTemplate>)template {
    NSURLComponents *components = [self componentsFromURLTemplate:template];
    if (components.URL != nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:components.URL];
        request.HTTPMethod = template.httpMethod;
        request.HTTPBody = template.httpBody;
        [template.httpHeaders enumerateObjectsUsingBlock:^(CMPHTTPHeader * _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj.value forHTTPHeaderField:obj.field];
        }];

        return request;
    }

    return nil;
}

@end
