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

#import "CMPProfileService.h"

#import "CMPRequestManager.h"
#import "CMPAPIConfiguration.h"
#import "CMPGetProfileTemplate.h"
#import "CMPUpdateProfileTemplate.h"
#import "CMPPatchProfileTemplate.h"
#import "CMPQueryProfilesTemplate.h"
#import "CMPQueryBuilder.h"
#import "CMPProfile.h"

@implementation CMPProfileService

- (void)getProfileWithProfileID:(NSString *)profileID completion:(void (^)(CMPResult<CMPProfile *> *))completion {
    CMPGetProfileTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetProfileTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID profileID:profileID token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPProfile *> * result) {
        completion(result);
    }];
}

- (void)updateProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *,NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void (^)(CMPResult<CMPProfile *> *))completion {
    CMPUpdateProfileTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPUpdateProfileTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID profileID:profileID token:token eTag:eTag attributes:attributes];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPProfile *> * result) {
        completion(result);
    }];
}

- (void)patchProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *,NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void (^)(CMPResult<CMPProfile *> *))completion {
    CMPPatchProfileTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPPatchProfileTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID profileID:profileID token:token eTag:eTag attributes:attributes];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPProfile *> * result) {
        completion(result);
    }];
}

- (void)queryProfilesWithQueryElements:(NSArray<CMPQueryElements *> *)queryElements completion:(void (^)(CMPResult<NSArray<CMPProfile *> *> *))completion {
    NSString *query = [CMPQueryBuilder buildQueryWithElements:queryElements];
    CMPQueryProfilesTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPQueryProfilesTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID token:token queryString:query];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSArray<CMPProfile *> *> * result) {
        completion(result);
    }];
}

@end
