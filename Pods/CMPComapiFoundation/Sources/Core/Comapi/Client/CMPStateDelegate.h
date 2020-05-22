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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Protocol responsible for observing session and socket state changes.
 */
NS_SWIFT_NAME(StateDelegate)
@protocol CMPStateDelegate <NSObject>

/**
 @brief The client's session started succesfully.
 @param profileID The profile that started the session.
 */
- (void)didStartSessionWithProfileID:(NSString *)profileID;

/**
 @brief The client's session ended with potential error.
 @param error An error that occurred.
 */
- (void)didEndSessionWithError:(NSError * _Nullable)error;

/**
 @brief The client's socket started succesfully.
 */
- (void)didConnectSocket;

/**
 @brief The client's socket disconnected with potential error.
 @param error An error that occurred.
 */
- (void)didDisconnectSocketWithError:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
