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

#import "CMPGetConversationsTemplate.h"

#import "CMPConversation.h"
#import "CMPHTTPHeader.h"
#import "CMPConstants.h"
#import "NSURLResponse+CMPUtility.h"
#import "CMPErrors.h"
#import "CMPRequestPerforming.h"

@interface CMPGetConversationsTemplate ()

- (NSString *)stringForConversationScope:(CMPConversationScope)scope;

@end

@implementation CMPGetConversationsTemplate

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host port:(NSUInteger)port apiSpaceID:(NSString *)apiSpaceID profileID:(NSString *)profileID scope:(CMPConversationScope)scope token:(NSString *)token {
    self = [super initWithScheme:scheme host:host port:port apiSpaceID:apiSpaceID];
    
    if (self) {
        self.conversationScope = scope;
        self.profileID = profileID;
        self.token = token;
    }
    
    return self;
}

- (NSString *)stringForConversationScope:(CMPConversationScope)scope {
    switch (scope) {
        case CMPConversationScopePublic:
            return @"public";
        case CMPConversationScopeParticipant:
            return @"participant";
    }
}

- (nullable NSData *)httpBody { 
    return nil;
}

- (nullable NSSet<CMPHTTPHeader *> *)httpHeaders { 
    CMPHTTPHeader *contentType = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderContentType value:@"application/json"];
    CMPHTTPHeader *authorization = [[CMPHTTPHeader alloc] initWithField:CMPHTTPHeaderAuthorization value:[NSString stringWithFormat:@"Bearer %@", self.token]];
    return [NSSet setWithObjects:contentType, authorization, nil];
}

- (nonnull NSString *)httpMethod { 
    return CMPHTTPMethodGET;
}

- (nonnull NSArray<NSString *> *)pathComponents { 
    return @[@"apispaces", self.apiSpaceID, @"conversations"];
}

- (nullable NSDictionary<NSString *,NSString *> *)query {
    NSMutableDictionary<NSString *, NSString *> *query = [NSMutableDictionary new];
    if (self.conversationScope != CMPConversationScopeParticipant) {
        query[@"scope"] = [self stringForConversationScope:self.conversationScope];
    }
    if (self.profileID) {
        query[@"profileId"] = self.profileID;
    }
    return query;
}

- (CMPResult<id> *)resultFromData:(NSData *)data urlResponse:(NSURLResponse *)response netError:(nullable NSError *)netError {
    NSInteger code = [response httpStatusCode];
    NSString *eTag = [[response httpURLResponse] allHeaderFields][@"ETag"];
    switch (code) {
        case 200: {
            __block NSError *parseError = nil;
            NSArray<NSDictionary<NSString *, id> *> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@", json);
            if (parseError) {
                NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorResponseParsingFailed underlyingError:parseError];
                return [[CMPResult alloc] initWithObject:nil error:error eTag:eTag code:code];
            }
            NSMutableArray<CMPConversation *> *conversations = [NSMutableArray new];
            
            [json enumerateObjectsUsingBlock:^(NSDictionary<NSString *, id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [conversations addObject:[CMPConversation decodeWithData:[NSJSONSerialization dataWithJSONObject:obj options:0 error:&parseError]]];
            }];
            
            NSArray<CMPConversation *> *object = [NSArray arrayWithArray:conversations];
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
    NSURLRequest *request = [self requestFromHTTPRequestTemplate:self];
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
