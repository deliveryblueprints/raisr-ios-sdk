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

@import Foundation;

#import "CMPServices.h"
#import "CMPRequestManagerDelegate.h"
#import "CMPSocketDelegate.h"
#import "CMPSessionDelegate.h"
#import "CMPStateDelegate.h"
#import "CMPBroadcastDelegate.h"
#import "CMPSDKState.h"

@class CMPRequestManager;
@class CMPSocketManager;
@class CMPSessionManager;
@class CMPServices;

@protocol CMPEventDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief The main class used to communicate with Comapi services, WebSocket events and Push configuration.
 @discussion To access services use:
 @code
 client.services.profile
 client.services.messaging
 client.services.session
 @endcode
 @discussion To listen for events, conform a custom class to CMPEventDelegate and call:
 @code
 - (void)addEventDelegate:(id<CMPEventDelegate>)delegate;
 @endcode
 @discussion To configure push notifications call:
 @code
 - (void)setPushToken:(NSString *)deviceToken completion:(void(^)(BOOL, NSError * _Nullable))completion;
 @endcode
 @discussion With a deviceToken obtained in the AppDelegate.
 */
NS_SWIFT_NAME(ComapiClient)
@interface CMPComapiClient: NSObject <CMPRequestManagerDelegate, CMPSocketDelegate, CMPSessionDelegate>
/// Current SDK state
@property (atomic) CMPSDKState state;
/// All Comapi services categorized by funcionality
@property (nonatomic, strong, readonly) CMPServices *services;
/// ProfileId the client is bound to.
@property (nonatomic, strong, readonly, nullable, getter=getProfileID) NSString *profileID;
/// Checks if the client's session object is configured and ready to perform service requests.
@property (nonatomic, readonly, getter=isSessionSuccessfullyCreated) BOOL sessionSuccesfullyCreated;

@property (nonatomic, strong, readonly) CMPBroadcastDelegate<id<CMPStateDelegate>> *stateDelegates;

- (instancetype)init NS_UNAVAILABLE;

/**
 @brief Get logs saved to file.
 @return NSData object containing contents of the log file or nil if error occurs or there are no logs.
*/
- (nullable NSData *)getFileLogs NS_SWIFT_NAME(getFileLogs());

/**
 @brief Registers Comapi push notifications.
 @discussion Use UIApplication's method:
 @code
 [[UIApplication sharedApplication] registerForRemoteNotifications];
 @endcode
 @discussion And pass the token retrieved in UIApplicationDelegate's method:
 @code
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
 @endcode
 @discussion To the deviceToken parameter.
 @param deviceToken Token retrieved from UIApplicationDelegate callback method.
 @param completion Completion block with a BOOL value determining if registration was successful and a potential NSError.
 */
- (void)setPushToken:(NSString *)deviceToken completion:(void(^)(BOOL, NSError * _Nullable))completion NS_SWIFT_NAME(set(pushToken:completion:));

/**
 @brief Adds an event listener, CMPEventDelegate conforming object to listen for incoming events.
 @param delegate CMPEventDelegate conforming object that will recieve events.
 */
- (void)addEventDelegate:(id<CMPEventDelegate>)delegate;

/**
 @brief Removes a CMPEventDelegate listener if it is registered or does nothing.
 @param delegate CMPEventDelegate conforming object that should be removed from registered delegates.
 */
- (void)removeEventDelegate:(id<CMPEventDelegate>)delegate;

/**
 @brief Adds a state listener, CMPStateDelegate conforming object to listen for user login and socket state changes.
 @param delegate CMPStateDelegate conforming object that will receive state changes.
 */
- (void)addStateDelegate:(id<CMPStateDelegate>)delegate;

/**
 @brief Removes a CMPStateDelegate listener if it is registered or does nothing.
 @param delegate CMPStateDelegate conforming object that should be removed from registered delegates.
 */
- (void)removeStateDelegate:(id<CMPStateDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
