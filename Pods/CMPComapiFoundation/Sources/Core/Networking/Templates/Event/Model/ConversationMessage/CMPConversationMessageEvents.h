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

#import "CMPEvent.h"

@class CMPMessagePart;
@class CMPMessageAlert;
@class CMPMessageContext;

@protocol CMPJSONRepresentable;
@protocol CMPJSONConstructable;
@protocol CMPJSONDecoading;
@protocol CMPJSONEncoding;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ConversationMessage

NS_SWIFT_NAME(ConversationMessageEvent)
@interface CMPConversationMessageEvent : CMPEvent

@property (nonatomic, strong, nullable) NSNumber *conversationEventID;

@end

#pragma mark - Delivered

NS_SWIFT_NAME(ConversationMessageEventDeliveredPayload)
@interface CMPConversationMessageEventDeliveredPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSDate *timestamp;

@end

NS_SWIFT_NAME(ConversationMessageEventDelivered)
@interface CMPConversationMessageEventDelivered : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationMessageEventDeliveredPayload *payload;

@end

#pragma mark - Read

NS_SWIFT_NAME(ConversationMessageEventReadPayload)
@interface CMPConversationMessageEventReadPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSDate *timestamp;

@end

NS_SWIFT_NAME(ConversationMessageEventRead)
@interface CMPConversationMessageEventRead : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationMessageEventReadPayload *payload;

@end

#pragma mark - Sent

NS_SWIFT_NAME(ConversationMessageEventSentPayload)
@interface CMPConversationMessageEventSentPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *metadata;
@property (nonatomic, strong, nullable) NSArray<CMPMessagePart *> *parts;
@property (nonatomic, strong, nullable) CMPMessageContext *context;
@property (nonatomic, strong, nullable) CMPMessageAlert *alert;

@end

NS_SWIFT_NAME(ConversationMessageEventSent)
@interface CMPConversationMessageEventSent : CMPConversationMessageEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) NSDate *publishedOn;
@property (nonatomic, strong, nullable) CMPConversationMessageEventSentPayload *payload;

@end

NS_ASSUME_NONNULL_END
