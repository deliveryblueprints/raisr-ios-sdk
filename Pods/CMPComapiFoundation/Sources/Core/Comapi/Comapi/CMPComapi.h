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

@class CMPComapiClient;
@class CMPComapiConfig;
@class CMPLogger;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Client interface class used for initializing and retrieving CMPComapiClient.
 */
NS_SWIFT_NAME(Comapi)
@interface CMPComapi : NSObject

/**
 @discussion Singleton client instance.
 @warning Only available if you call:
 @code
 + (nullable CMPComapiClient *)initialiseSharedInstanceWithConfig:(CMPComapiConfig *)config;
 @endcode
 */
@property (class, nonatomic, strong, readonly, nullable) CMPComapiClient *shared;

- (instancetype)init NS_UNAVAILABLE;

/**
 @brief Creates an instance of CMPComapiClient with given configuration.
 @param config CMPComapiConfig object created with specified configuration elements.
 @return CMPComapiClient object or nil if error occurs.
 */
+ (nullable CMPComapiClient *)initialiseWithConfig:(__kindof CMPComapiConfig *)config;

/**
 @discussion Creates an instance of CMPComapiClient with given configuration that can be accessed via:
 @code
 [CMPComapi shared];
 @endcode
 @param config CMPComapiConfig object created with specified configuration elements.
 @return CMPComapiClient object or nil if error occurs.
 */
+ (nullable CMPComapiClient *)initialiseSharedInstanceWithConfig:(__kindof CMPComapiConfig *)config;

@end

NS_ASSUME_NONNULL_END
