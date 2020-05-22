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

#import "CMPErrors.h"
#import "CMPConstants.h"

@implementation CMPErrors

+ (NSError *)requestTemplateErrorWithStatus:(CMPRequestTemplateError)status underlyingError:(NSError *)error {
    switch (status) {
        case CMPRequestTemplateErrorRequestCreationFailed:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorRequestCreationFailedStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorResponseParsingFailed:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorResponseParsingFailedStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorConnectionFailed:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorConnectionFailedStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorUnexpectedStatusCode:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorWrongCodeStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorNotFound:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorNotFoundStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorUpdateConflict:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorUpdateConflictStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorETagMismatch:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorETagMismatchStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
        case CMPRequestTemplateErrorAlreadyExists:
            return [[NSError alloc] initWithDomain:CMPRequestTemplateErrorDomain code:CMPRequestTemplateErrorUpdateConflictStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
    }
}

+ (NSError *)authenticationErrorWithStatus:(CMPAuthenticationError)status underlyingError:(NSError *)error {
    switch (status) {
        case CMPAuthenticationErrorMissingToken:
            return [[NSError alloc] initWithDomain:CMPAuthenticationErrorDomain code:CMPAuthenticationErrorMissingTokenStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
    }
}

+ (NSError *)conversationErrorWithStatus:(CMPConversationError)status underlyingError:(NSError *)error {
    switch (status) {
        case CMPConversationErrorNotFound:
            return [[NSError alloc] initWithDomain:CMPConversationErrorDomain code:CMPConversationErrorNotFoundStatusCode userInfo:error != nil ? @{NSUnderlyingErrorKey : error} : @{}];
            
    }
}

@end
