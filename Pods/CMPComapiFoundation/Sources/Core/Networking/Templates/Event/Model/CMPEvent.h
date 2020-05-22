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

#import "CMPJSONDecoding.h"
#import "CMPJSONRepresentable.h"

@class CMPEventContext;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CMPEventType) {
    CMPEventTypeConversationCreate,
    CMPEventTypeConversationUpdate,
    CMPEventTypeConversationDelete,
    CMPEventTypeConversationUndelete,
    CMPEventTypeConversationParticipantAdded,
    CMPEventTypeConversationParticipantRemoved,
    CMPEventTypeConversationParticipantUpdated,
    CMPEventTypeConversationParticipantTyping,
    CMPEventTypeConversationParticipantTypingOff,
    CMPEventTypeSocketInfo,
    CMPEventTypeProfileUpdate,
    CMPEventTypeConversationMessageDelivered,
    CMPEventTypeConversationMessageSent,
    CMPEventTypeConversationMessageRead,
    CMPEventTypeNone
} NS_SWIFT_NAME(EventType);

NS_SWIFT_NAME(Event)
@interface CMPEvent : NSObject <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSString *eventID;
@property (nonatomic, strong, nullable) NSString *apiSpaceID;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) CMPEventContext *context;
@property (nonatomic) CMPEventType type;

@end

NS_SWIFT_NAME(EventContext)
@interface CMPEventContext : NSObject <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong) NSString *createdBy;

@end

NS_ASSUME_NONNULL_END
