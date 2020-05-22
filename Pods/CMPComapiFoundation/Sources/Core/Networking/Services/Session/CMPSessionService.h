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

#import "CMPBaseService.h"
#import "CMPResult.h"

@protocol CMPAuthChallengeHandler;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(SessionServiceable)
@protocol CMPSessionServiceable <NSObject>

/**
 @brief Starts a Comapi session allowing for further Comapi service calls.
 @param completion Block called on success.
 @param failure Block called on failure, returns an NSError if one occurs.
 */
- (void)startSessionWithCompletion:(void(^)(void))completion failure:(void(^)(NSError * _Nullable))failure NS_SWIFT_NAME(startSession(completion:failure:));

/**
 @brief Ends a Comapi session.
 @param completion Block with a result value, the @b object returned is of type @a NSNumber* (mapping to BOOL determining successful session finish) or nil if an error occurred.
 */
- (void)endSessionWithCompletion:(void (^)(CMPResult<NSNumber *> *))completion
    NS_SWIFT_NAME(endSession(completion:));

/**
 @brief Part of session starting procedure, asks the passed challangeHandler to provide a valid JWT authentication token.
 @param challengeHandler A CMPAuthChallengeHandler conforming object providing a JWT token.
 @warning Do not call this method or implement your own @a CMPAuthChallengeHandler, sessions are handled by @a CMPSessionManager.
 */
- (void)startAuthenticationWithChallengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler NS_SWIFT_NAME(startAuthentication(challengeHandler:));

/**
 @brief Part of session starting procedure, the obtained token is sent back to Comapi servers for validation.
 @param token The obtained authentication token.
 @param authenticationID Authentication token Id.
 @param challengeHandler A CMPAuthChallengeHandler conforming object providing a JWT token.
 @warning Do not call this method, sessions are handled by @a CMPSessionManager.
 */
- (void)continueAuthenticationWithToken:(NSString *)token forAuthenticationID:(NSString *)authenticationID challengeHandler:(id<CMPAuthChallengeHandler>)challengeHandler
    NS_SWIFT_NAME(continueAuthentication(token:authenticationID:challengeHandler:));

@end

/**
 @brief Session related Comapi services.
 */
NS_SWIFT_NAME(SessionService)
@interface CMPSessionService : CMPBaseService <CMPSessionServiceable>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
