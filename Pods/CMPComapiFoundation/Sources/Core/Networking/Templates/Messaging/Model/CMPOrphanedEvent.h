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

#import "CMPJSONRepresentable.h"
#import "CMPJSONDecoding.h"
#import "CMPMessageDeliveryStatus.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(OrphanedEventPayload)
@interface CMPOrphanedEventPayload : NSObject <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *messageID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSNumber *isPublicConversation;
@property (nonatomic, strong, nullable) NSDate *timestamp;

- (instancetype)initWithProfileID:(nullable NSString *)profileID messageID:(nullable NSString *)messageID conversationID:(nullable NSString *)conversationID isPublicConversation:(nullable NSNumber *)isPublicConversation timestamp:(nullable NSDate *)timestamp;

@end

NS_SWIFT_NAME(OrphanedEventData)
@interface CMPOrphanedEventData : NSObject <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *eventID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) CMPOrphanedEventPayload *payload;

- (instancetype)initWithName:(nullable NSString *)name eventID:(nullable NSString *)eventID profileID:(nullable NSString *)profileID payload:(nullable CMPOrphanedEventPayload *)payload;

@end

NS_SWIFT_NAME(OrphanedEvent)
@interface CMPOrphanedEvent : NSObject <CMPJSONDecoding, CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSNumber *id;
@property (nonatomic, strong, nullable) CMPOrphanedEventData *data;

@property (nonatomic, readonly) CMPMessageDeliveryStatus status;

- (instancetype)initWithID:(nullable NSNumber *)ID data:(nullable CMPOrphanedEventData *)data;

@end

NS_ASSUME_NONNULL_END
