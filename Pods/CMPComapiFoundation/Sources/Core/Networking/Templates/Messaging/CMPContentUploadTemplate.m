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

#import "CMPContentUploadTemplate.h"

#import "CMPContentUploadResult.h"
#import "CMPContentData.h"
#import "CMPHTTPHeader.h"
#import "CMPConstants.h"
#import "NSURLResponse+CMPUtility.h"
#import "CMPErrors.h"
#import "CMPRequestPerforming.h"

@interface CMPContentUploadTemplate ()

- (NSURLRequest *)requestFromHTTPStreamableRequestTemplate:(id<CMPHTTPStreamableRequestTemplate>)template;

@end

@implementation CMPContentUploadTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID content:(CMPContentData *)content folder:(NSString *)folder token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.content = content;
        self.folder = folder;
        self.token = token;
    }
    
    return self;
}

- (NSURLRequest *)requestFromHTTPStreamableRequestTemplate:(id<CMPHTTPStreamableRequestTemplate>)template {
    NSURLComponents *components = [self componentsFromURLTemplate:template];
    if (components.URL != nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:components.URL];
        request.HTTPMethod = template.httpMethod;
        request.HTTPBodyStream = template.httpBodyStream;
        
        [template.httpHeaders enumerateObjectsUsingBlock:^(CMPHTTPHeader * _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj.value forHTTPHeaderField:obj.field];
        }];
        
        return request;
    }
    
    return nil;
}

- (nullable NSInputStream *)httpBodyStream {
    return [NSInputStream inputStreamWithData:[self.content encode]];
}

- (nullable NSData *)httpBody {
    return nil;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders {
    CMPHTTPHeader *contentFilename = [[CMPHTTPHeader alloc] initWithField:@"Content-Filename" value:self.content.name ? self.content.name : @""];
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:[NSString stringWithFormat:@"Bearer %@", self.token]];
    return [NSSet setWithObjects:contentFilename, contentType, authorization, nil];
}

- (nonnull NSString *)httpMethod {
    return CMPHTTPMethodPOST;
}

- (nonnull NSArray<NSString *> *)pathComponents {
    return @[@"apispaces", self.apiSpaceID, @"content"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    if (self.folder) {
        return @{@"folder" : self.folder};
    }
    return nil;
}

- (CMPResult<id> *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response netError:(nullable NSError *)netError{
    NSInteger code = [response httpStatusCode];
    NSString *eTag = [[response httpURLResponse] allHeaderFields][@"ETag"];
    switch (code) {
        case 200: {
            CMPContentUploadResult *object = [CMPContentUploadResult decodeWithData:data];
            return [[CMPResult alloc] initWithObject:object error:nil eTag:eTag code:code];
        }
        case 404: {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorNotFound underlyingError:netError];
            return [[CMPResult alloc] initWithObject:nil error:error eTag:eTag code:code];
        }
        default: {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorUnexpectedStatusCode underlyingError:netError];
            return [[CMPResult alloc] initWithObject:nil error:error eTag:eTag code:code];
        }
    }
}

- (void)performWithRequestPerformer:(id<CMPRequestPerforming>)performer result:(void (^)(CMPResult<id> *))result {
    NSURLRequest *request = [self requestFromHTTPStreamableRequestTemplate:self];
    if (!request) {
        NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorRequestCreationFailed underlyingError:nil];
        result([[CMPResult alloc] initWithObject:nil error:error eTag:nil code:error.code]);
        return;
    }
    
    [performer performRequest:request completion:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        result([self resultFromData:data urlResponse:response netError:error]);
    }];
}

@end
