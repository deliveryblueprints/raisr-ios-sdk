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

NS_ASSUME_NONNULL_BEGIN

/**
 @typedef CMPLogLevel
 @brief Defines the verbosity of logs.
 */
typedef NS_ENUM(NSUInteger, CMPLogLevel) {
    /// Most verbose debugging level - displays everything.
    CMPLogLevelVerbose = 0,
    /// Less verbose level.
    CMPLogLevelDebug,
    /// Only displays crucial information, warnings and errors.
    CMPLogLevelInfo,
    /// Only displays warnings and errors.
    CMPLogLevelWarning,
    /// Only displays errors.
    CMPLogLevelError
} NS_SWIFT_NAME(LogLevel);

NS_SWIFT_NAME(LogLevelRepresenter)
@interface CMPLogLevelRepresenter: NSObject

+ (NSString *)emojiRepresentationForLogLevel:(CMPLogLevel)logLevel;
+ (NSString *)textualRepresentationForLogLevel:(CMPLogLevel)logLevel;

@end

NS_ASSUME_NONNULL_END
