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
#import "CMPRole.h"

@class CMPRoles;
@class CMPConversationParticipant;

@protocol CMPJSONRepresentable;
@protocol CMPJSONConstructable;
@protocol CMPJSONDecoading;
@protocol CMPJSONEncoding;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Conversation

NS_SWIFT_NAME(ConversationEvent)
@interface CMPConversationEvent : CMPEvent <CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSNumber *conversationEventID;

@end

#pragma mark - Create

NS_SWIFT_NAME(ConversationEventCreatePayload)
@interface CMPConversationEventCreatePayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSNumber *isPublic;
@property (nonatomic, strong, nullable) CMPRoles *roles;
@property (nonatomic, strong, nullable) NSArray<CMPConversationParticipant *> *participants;

@end

NS_SWIFT_NAME(ConversationEventCreate)
@interface CMPConversationEventCreate : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventCreatePayload *payload;

@end

#pragma mark - Update

NS_SWIFT_NAME(ConversationEventCreatePayload)
@interface CMPConversationEventUpdatePayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *eventDescription;
@property (nonatomic, strong, nullable) NSNumber *isPublic;
@property (nonatomic, strong, nullable) CMPRoles *roles;

@end

NS_SWIFT_NAME(ConversationEventUpdate)
@interface CMPConversationEventUpdate : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventUpdatePayload *payload;

@end

#pragma mark - Delete

NS_SWIFT_NAME(ConversationEventDeletePayload)
@interface CMPConversationEventDeletePayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSDate *date;

@end

NS_SWIFT_NAME(ConversationEventDelete)
@interface CMPConversationEventDelete : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventDeletePayload *payload;

@end

#pragma mark - Undelete

NS_SWIFT_NAME(ConversationEventUndeletePayload)
@interface CMPConversationEventUndeletePayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *id;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *eventDescription;
@property (nonatomic, strong, nullable) NSNumber *isPublic;
@property (nonatomic, strong, nullable) CMPRoles *roles;

@end

NS_SWIFT_NAME(ConversationEventUndelete)
@interface CMPConversationEventUndelete : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventUndeletePayload *payload;

@end

#pragma mark - ParticipantAdded

NS_SWIFT_NAME(ConversationEventParticipantAddedPayload)
@interface CMPConversationEventParticipantAddedPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *apiSpaceID;
@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic) CMPRole role;

@end

NS_SWIFT_NAME(ConversationEventParticipantAdded)
@interface CMPConversationEventParticipantAdded : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantAddedPayload *payload;

@end

#pragma mark - ParticipantRemoved

NS_SWIFT_NAME(ConversationEventParticipantRemovedPayload)
@interface CMPConversationEventParticipantRemovedPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *apiSpaceID;

@end

NS_SWIFT_NAME(ConversationEventParticipantRemoved)
@interface CMPConversationEventParticipantRemoved : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantRemovedPayload *payload;

@end

#pragma mark - ParticipantUpdated

NS_SWIFT_NAME(ConversationEventParticipantUpdatedPayload)
@interface CMPConversationEventParticipantUpdatedPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;
@property (nonatomic, strong, nullable) NSString *apiSpaceID;
@property (nonatomic) CMPRole role;

@end

NS_SWIFT_NAME(ConversationEventParticipantUpdated)
@interface CMPConversationEventParticipantUpdated : CMPConversationEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantUpdatedPayload *payload;

@end

#pragma mark - ParticipantTyping

NS_SWIFT_NAME(ParticipantTypingEvent)
@interface CMPParticipantTypingEvent : CMPEvent <CMPJSONRepresentable>

@property (nonatomic, strong, nullable) NSNumber *accountID;
@property (nonatomic, strong, nullable) NSDate *publishedOn;

@end

#pragma mark - ParticipantTypingOn

NS_SWIFT_NAME(ConversationEventParticipantTypingPayload)
@interface CMPConversationEventParticipantTypingPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;

@end

NS_SWIFT_NAME(ConversationEventParticipantTyping)
@interface CMPConversationEventParticipantTyping : CMPParticipantTypingEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantTypingPayload *payload;

@end

#pragma mark - ParticipantTypingOff

NS_SWIFT_NAME(ConversationEventParticipantTypingOffPayload)
@interface CMPConversationEventParticipantTypingOffPayload : NSObject <CMPJSONRepresentable, CMPJSONConstructable>

@property (nonatomic, strong, nullable) NSString *profileID;
@property (nonatomic, strong, nullable) NSString *conversationID;

@end

NS_SWIFT_NAME(ConversationEventParticipantTypingOff)
@interface CMPConversationEventParticipantTypingOff : CMPParticipantTypingEvent <CMPJSONDecoding>

@property (nonatomic, strong, nullable) CMPConversationEventParticipantTypingOffPayload *payload;

@end

NS_ASSUME_NONNULL_END
