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

#import "CMPSessionManager.h"

#import "CMPRequestManager.h"
#import "CMPSocketManager.h"
#import "CMPSession.h"
#import "CMPServices.h"
#import "CMPKeychain.h"
#import "CMPLogger.h"
#import "CMPErrors.h"
#import "CMPConstants.h"
#import "CMPSessionAuth.h"
#import "CMPComapiClient.h"

NSString * const authTokenKeychainItemNamePrefix = @"ComapiSessionToken_";
NSString * const sessionDetailsUserDefaultsPrefix = @"ComapiSessionDetails_";

@interface CMPSessionManager ()

@property (nonatomic, weak, nullable) CMPComapiClient *client;
@property (nonatomic, weak, nullable) CMPSocketManager *socketManager;
@property (nonatomic, weak, nullable) id<CMPAuthenticationDelegate> authenticationDelegate;
@property (nonatomic, weak, nullable) id<CMPSessionDelegate> sessionDelegate;

@property (nonatomic, strong) CMPRequestManager *requestManager;

@property (nonatomic, copy, nullable) void(^didFinishAuthentication)(void);
@property (nonatomic, copy, nullable) void(^didFailAuthentication)(NSError *);

@property (nonatomic, copy) NSString* apiSpaceID;
@property (nonatomic, copy) NSString* tokenKey;
@property (nonatomic, copy) NSString* detailsKey;

- (void)loadSessionInfo;
- (void)saveSessionInfo;

@end

@implementation CMPSessionManager

@synthesize sessionAuth = _sessionAuth;

- (instancetype)initWithApiSpaceID:(NSString *)apiSpaceID authenticationDelegate:(id<CMPAuthenticationDelegate>)delegate requestManager:(CMPRequestManager *)requestManager sessionDelegate:(id<CMPSessionDelegate>)sessionDelegate {
    self = [super init];
    
    if (self) {
        self.apiSpaceID = apiSpaceID;
        self.authenticationDelegate = delegate;
        self.sessionDelegate = sessionDelegate;
        self.requestManager = requestManager;
        self.tokenKey = [NSString stringWithFormat:@"%@%@", authTokenKeychainItemNamePrefix, self.apiSpaceID];
        self.detailsKey = [NSString stringWithFormat:@"%@%@", sessionDetailsUserDefaultsPrefix, self.apiSpaceID];
        
        [self loadSessionInfo];
    }
    
    return self;
}

- (BOOL)isSessionValid {
    if (_sessionAuth != nil && _sessionAuth.session != nil && _sessionAuth.session.expiresOn != nil) {
        return _sessionAuth.session.isActive && [[NSDate date] compare:_sessionAuth.session.expiresOn] == NSOrderedAscending;
    }
    
    return false;
}

- (void)bindClient:(CMPComapiClient *)client {
    self.client = client;
}

- (void)bindSocketManager:(CMPSocketManager *)socketManager {
    self.socketManager = socketManager;
}

- (void)loadSessionInfo {
    if ([CMPKeychain loadItemForKey:self.tokenKey] == nil || [[NSUserDefaults standardUserDefaults] objectForKey:self.detailsKey] == nil) {
        self.sessionAuth = nil;
        return;
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:self.detailsKey];
    CMPSession *session = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *token = [CMPKeychain loadItemForKey:self.tokenKey];
    if (token && session) {
        CMPSessionAuth *sessionAuth = [[CMPSessionAuth alloc] initWithToken:token session:session];
        self.sessionAuth = sessionAuth;
        if (self.isSessionValid) {
            [self.requestManager updateToken:token];
            [self.socketManager updateToken:token];
        } else {
            [self authenticateWithSuccess:nil failure:nil];
        }
    }
}

- (void)saveSessionInfo {
    if (!_sessionAuth) {
        return;
    }
    
    [CMPKeychain saveItem:_sessionAuth.token forKey:self.tokenKey];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_sessionAuth.session];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:self.detailsKey];
    }
}

#pragma mark - CMPAuthChallengeHandler

- (void)authenticationFailedWithError:(nonnull NSError *)error {
    [self.requestManager tokenUpdateFailed];
    [self.sessionDelegate didEndSessionWithError:error];
    
    if (self.didFailAuthentication) {
        self.didFailAuthentication(error);
    }
    
    self.client.state = CMPSDKStateSessionOff;
}

- (void)authenticationFinishedWithSessionAuth:(nonnull CMPSessionAuth *)sessionAuth {
    logWithLevel(CMPLogLevelInfo, @"Authorization finished with sessionAuth:", sessionAuth, nil);
    
    _sessionAuth = sessionAuth;
    [self saveSessionInfo];
    [self.requestManager updateToken:sessionAuth.token];
    [self.socketManager updateToken:sessionAuth.token];
    [self.socketManager startSocket];
    
    NSTimeInterval secondsTillTokenExpiry = sessionAuth.session.expiresOn.timeIntervalSinceNow;
    logWithLevel(CMPLogLevelInfo, @"secondsTillTokenExpiry:", @(secondsTillTokenExpiry), nil);
    
    [self.sessionDelegate didStartSession];
    
    if (self.didFinishAuthentication) {
        self.didFinishAuthentication();
    }
    
    self.client.state = CMPSDKStateSessionActive;
    
    __weak CMPSessionManager *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secondsTillTokenExpiry * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if ([weakSelf.sessionAuth.session.id isEqualToString:sessionAuth.session.id]) {
            [weakSelf authenticateWithSuccess:nil failure:nil];
        }
    });
}

- (void)handleAuthenticationChallenge:(nonnull CMPAuthenticationChallenge *)challenge {
    __weak CMPSessionManager *weakSelf = self;
    [self.authenticationDelegate client:self.client didReceiveAuthenticationChallenge:challenge completion:^(NSString * _Nullable token) {
        if (token) {
            NSString *authenticationID = challenge.authenticationID != nil ? challenge.authenticationID : @"";
            [weakSelf.client.services.session continueAuthenticationWithToken:token forAuthenticationID:authenticationID challengeHandler:self];
        } else {
            [weakSelf authenticationFailedWithError:[CMPErrors authenticationErrorWithStatus:CMPAuthenticationErrorMissingTokenStatusCode underlyingError:nil]];
        }
    }];
}

#pragma mark - CMPSessionAuthProvider

- (void)authenticateWithSuccess:(void(^)(void))success failure:(void(^)(NSError *))failure {
    if (self.client) {
        self.client.state = CMPSDKStateSessionStarting;
        self.didFinishAuthentication = success;
        self.didFailAuthentication = failure;
        [self.socketManager closeSocket];
        [self.client.services.session startAuthenticationWithChallengeHandler:self];
    }
}

@end
