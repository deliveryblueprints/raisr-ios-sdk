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

#import "CMPRequestManager.h"

#import "CMPRequestManagerDelegate.h"
#import "CMPPendingOperation.h"
#import "CMPTokenState.h"
#import "CMPHTTPRequestTemplate.h"
#import "CMPErrors.h"

@interface CMPRequestManager ()

@property (nonatomic, strong) NSMutableArray<CMPPendingOperation>* pendingOperations;
@property (nonatomic) CMPTokenState tokenState;
@property (nonatomic, strong, nullable) NSString *token;

@end

@implementation CMPRequestManager

- (instancetype)initWithRequestPerformer:(id<CMPRequestPerforming>)requestPerformer {
    self = [super init];
    
    if (self) {
        self.requestPerformer = requestPerformer;
        self.pendingOperations = [NSMutableArray new];
        self.tokenState = CMPTokenStateMissing;
    }
    
    return self;
}

- (void)performUsingTemplateBuilder:(id<CMPHTTPRequestTemplate>(^)(NSString *))templateBuilder completion:(void(^)(CMPResult<id> *))completion {
    __weak typeof(self) weakSelf = self;
    switch (self.tokenState) {
        case CMPTokenStateMissing: {
            [self.pendingOperations addObject: [^{ [weakSelf performUsingTemplateBuilder:templateBuilder completion:completion]; } copy]];
            [self requestToken];
            break;
        }
        case CMPTokenStateAwaiting: {
            [self.pendingOperations addObject: [^{ [weakSelf performUsingTemplateBuilder:templateBuilder completion:completion]; } copy]];
            break;
        }
        case CMPTokenStateReady: {
            id<CMPHTTPRequestTemplate> template = templateBuilder(self.token);
            [template performWithRequestPerformer:self.requestPerformer result:^(CMPResult<id> * _Nonnull result) {
                completion(result);
            }];
            break;
        }
        case CMPTokenStateFailed: {
            NSError *error = [CMPErrors requestTemplateErrorWithStatus:CMPRequestTemplateErrorRequestCreationFailed underlyingError:nil];
            completion([[CMPResult alloc] initWithObject:nil error:error eTag:nil code:error.code]);
            break;
        }
    }
}

- (void)runAllPendingOperations {
    NSMutableArray<CMPPendingOperation> *operations = [self.pendingOperations copy];
    [self.pendingOperations removeAllObjects];
    [operations enumerateObjectsUsingBlock:^(CMPPendingOperation _Nonnull operation, NSUInteger idx, BOOL * _Nonnull stop) {
        operation();
    }];
}

- (void)requestToken {
    if (self.tokenState == CMPTokenStateAwaiting) {
        return;
    }
    
    if (self.delegate != nil) {
        [self.delegate requestManagerNeedsToken:self];
    } else {
        self.tokenState = CMPTokenStateFailed;
        [self runAllPendingOperations];
        self.tokenState = CMPTokenStateAwaiting;
    }
}

- (void)updateToken:(NSString *)token {
    self.token = token;
    self.tokenState = CMPTokenStateReady;
    [self runAllPendingOperations];
}

- (void)tokenUpdateFailed {
    self.tokenState = CMPTokenStateFailed;
    [self runAllPendingOperations];
    self.tokenState = CMPTokenStateMissing;
}

@end


