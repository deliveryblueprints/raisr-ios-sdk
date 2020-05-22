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
#import "CMPConversationScope.h"
#import "CMPMessageDeliveryStatus.h"
#import "CMPResult.h"

@class CMPEvent;
@class CMPConversationParticipant;
@class CMPConversation;
@class CMPNewConversation;
@class CMPConversationUpdate;
@class CMPGetMessagesResult;
@class CMPSendMessagesResult;
@class CMPSendableMessage;
@class CMPContentData;
@class CMPContentUploadResult;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MessagingServiceable)
@protocol CMPMessagingServiceable <NSObject>

#pragma mark - Events
/**
 @brief Queries events for specified conversationId.
 @param conversationID Id of a conversation to fetch events for.
 @param limit The amount of events to fetch.
 @param from Id of an event to offset the fetching from. Fetches @b limit number of events starting from event with @b from id.
 @param completion Block with a result value, the @b object returned is of type @a NSArray<CMPEvent*>* or nil if an error occurred.
 */
- (void)queryEventsWithConversationID:(NSString *)conversationID limit:(NSInteger)limit from:(NSInteger)from completion:(void(^)(CMPResult<NSArray<CMPEvent *> *> *))completion NS_SWIFT_NAME(queryEvents(conversationID:limit:from:completion:));

/**
 @brief Queries events for specified conversationId with a @b limit parameter defaulting to @a 100.
 @param conversationID Id of a conversation to fetch events for.
 @param from Id of an event to offset the fetching from. Fetches @b limit number of events starting from event with @b from id.
 @param completion Block with a result value, the @b object returned is of type @a NSArray<CMPEvent*>* or nil if an error occurred.
 */
- (void)queryEventsWithConversationID:(NSString *)conversationID from:(NSInteger)from completion:(void(^)(CMPResult<NSArray<CMPEvent *> *> *))completion NS_SWIFT_NAME(queryEvents(conversationID:from:completion:));

/**
 @brief Queries events for specified conversationId with @b from paramter set to 0, querying all the latest events up to @b limit.
 @param conversationID Id of a conversation to fetch events for.
 @param limit The amount of events to fetch.
 @param completion Block with a result value, the @b object returned is of type @a NSArray<CMPEvent*>* or nil if an error occurred.
 */
- (void)queryEventsWithConversationID:(NSString *)conversationID limit:(NSInteger)limit completion:(void(^)(CMPResult<NSArray<CMPEvent *> *> *))completion NS_SWIFT_NAME(queryEvents(conversationID:limit:completion:));

/**
 @brief Queries the latest @a 100 events for specified conversationId.
 @param conversationID Id of a conversation to fetch events for.
 @param completion Block with a result value, the @b object returned is of type @a NSArray<CMPEvent*>* or nil if an error occurred.
 */
- (void)queryEventsWithConversationID:(NSString *)conversationID completion:(void(^)(CMPResult<NSArray<CMPEvent *> *> *))completion NS_SWIFT_NAME(queryEvents(conversationID:completion:));

#pragma mark - ConversationParticipants

/**
 @brief Fetches participants for specified conversationId.
 @param conversationID Id of a conversation to fetch participants for.
 @param completion Block with a result value, the @b object returned is of type @a NSArray<CMPConversationParticipant*>* or nil if an error occurred.
 */
- (void)getParticipantsWithConversationID:(NSString *)conversationID completion:(void(^)(CMPResult<NSArray<CMPConversationParticipant *> *> *))completion NS_SWIFT_NAME(getParticipants(conversationID:completion:));

/**
 @brief Adds participants to converstion with specified Id.
 @param conversationID Id of a conversation to add participants to.
 @param completion Block with a result value, the @b object returned is of type @a NSNumber* (mapping to BOOL determining success of the sent request) or nil if an error occurred.
 */
- (void)addParticipantsWithConversationID:(NSString *)conversationID participants:(NSArray<CMPConversationParticipant *> *)participants completion:(void(^)(CMPResult<NSNumber *> *))completion NS_SWIFT_NAME(addParticipants(conversationID:participants:completion:));

/**
 @brief Removes participants from converstion with specified Id.
 @param conversationID Id of a conversation to remove participants from.
 @param completion Block with a result value, the @b object returned is of type @a NSNumber* (mapping to BOOL determining success of the sent request) or nil if an error occurred.
 */
- (void)removeParticipantsWithConversationID:(NSString *)conversationID participants:(NSArray<CMPConversationParticipant *> *)participants completion:(void(^)(CMPResult<NSNumber *> *))completion NS_SWIFT_NAME(removeParticipants(conversationID:participants:completion:));

/**
 @brief Sends an information that a participant started/stopped typing in conversation.
 @param conversationID Id of a conversation in which typing event occurred.
 @param completion Block with a result value, the @b object returned is of type @a NSNumber* (mapping to BOOL determining success of the sent request) or nil if an error occurred.
*/
- (void)participantIsTypingWithConversationID:(NSString *)conversationID isTyping:(BOOL)isTyping completion:(void(^)(CMPResult<NSNumber *> *))completion NS_SWIFT_NAME(participantIsTyping(conversationID:isTyping:completion:));

#pragma mark - Conversation

/**
 @brief Fetches a conversation with specified Id.
 @param conversationID Id of a conversation to fetch.
 @param completion Block with a result value, the @b object returned is of type @a CMPConversation* or nil if an error occurred.
 */
- (void)getConversationWithConversationID:(NSString *)conversationID completion:(void(^)(CMPResult<CMPConversation *> *))completion NS_SWIFT_NAME(getConversation(conversationID:completion:));

/**
 @brief Fetches conversations for specified profileId.
 @param profileID Id of a profile to fetch conversations for.
 @param isPublic Determines if public conversations should also be fetched. Value of @a NO only fetches private conversations.
 @param completion Block with a result value, the @b object returned is of type @a NSArray<CMPConversation*>* or nil if an error occurred.
 */
- (void)getConversationsWithProfileID:(NSString *)profileID isPublic:(BOOL)isPublic completion:(void(^)(CMPResult<NSArray<CMPConversation *> *> *))completion NS_SWIFT_NAME(getConversations(profileID:isPublic:completion:));

/**
 @brief Adds converstion with conversation details specified.
 @param conversation New conversation object with details regarding its configuration.
 @param completion Block with a result value, the @b object returned is of type @a CMPConversation* or nil if an error occurred.
 */
- (void)addConversationWithConversation:(CMPNewConversation *)conversation completion:(void(^)(CMPResult<CMPConversation *> *))completion NS_SWIFT_NAME(addConversation(conversation:completion:));

/**
 @brief Updates a converstion with update details specified.
 @param conversation Conversation update object with details regarding updated fields.
 @param completion Block with a result value, the @b object returned is of type @a CMPConversation* or nil if an error occurred.
 */
- (void)updateConversationWithConversationID:(NSString *)conversationID conversation:(CMPConversationUpdate *)conversation eTag:(nullable NSString *)eTag completion:(void(^)(CMPResult<CMPConversation *> *))completion NS_SWIFT_NAME(updateConversation(conversationID:conversation:eTag:completion:));

/**
 @brief Deletes a converstion with specified Id.
 @param conversationID Id of conversation to be deleted.
 @param completion Block with a result value, the @b object returned is of type @a NSNumber* (mapping to BOOL determining success of the sent request) or nil if an error occurred.
 */
- (void)deleteConversationWithConversationID:(NSString *)conversationID eTag:(nullable NSString *)eTag completion:(void(^)(CMPResult<NSNumber *> *))completion NS_SWIFT_NAME(deleteConversation(conversationID:eTag:completion:));

#pragma mark - Messages

/**
 @brief Fetches messages for specified conversationID.
 @param conversationID Id of a conversation to fetch events for.
 @param limit The amount of messages to fetch.
 @param from Id of a message to offset the fetching from. Fetches @b limit number of messages starting from event with @b from id.
 @param completion Block with a result value, the @b object returned is of type @a CMPGetMessagesResult* or nil if an error occurred.
 */
- (void)getMessagesWithConversationID:(NSString *)conversationID limit:(NSInteger)limit from:(NSInteger)from completion:(void(^)(CMPResult<CMPGetMessagesResult *> *))completion NS_SWIFT_NAME(getMessages(conversationID:limit:from:completion:));

/**
 @brief Fetches messages for specified conversationID with a @b limit parameter defaulting to @a 100.
 @param conversationID Id of a conversation to fetch events for.
 @param from Id of a message to offset the fetching from. Fetches @b limit number of messages starting from event with @b from id.
 @param completion Block with a result value, the @b object returned is of type @a CMPGetMessagesResult* or nil if an error occurred.
 */
- (void)getMessagesWithConversationID:(NSString *)conversationID from:(NSInteger)from completion:(void(^)(CMPResult<CMPGetMessagesResult *> *))completion NS_SWIFT_NAME(getMessages(conversationID:from:completion:));

/**
 @brief Fetches messages for specified conversationID with @b from parameter set to 0, querying all the latest events up to @b limit.
 @param conversationID Id of a conversation to fetch events for.
 @param limit The amount of messages to fetch.
 @param completion Block with a result value, the @b object returned is of type @a CMPGetMessagesResult* or nil if an error occurred.
 */
- (void)getMessagesWithConversationID:(NSString *)conversationID limit:(NSInteger)limit completion:(void(^)(CMPResult<CMPGetMessagesResult *> *))completion NS_SWIFT_NAME(getMessages(conversationID:limit:completion:));

/**
 @brief Queries the latest @a 100 messages for specified conversationID.
 @param conversationID Id of a conversation to fetch events for.
 @param completion Block with a result value, the @b object returned is of type @a CMPGetMessagesResult* or nil if an error occurred.
 */
- (void)getMessagesWithConversationID:(NSString *)conversationID completion:(void(^)(CMPResult<CMPGetMessagesResult *> *))completion NS_SWIFT_NAME(getMessages(conversationID:completion:));

/**
 @brief Fetches messages for specified conversationID.
 @param message New message object with details regarding the message's contents.
 @param conversationID Id of a conversation to send message to.
 @param completion Block with a result value, the @b object returned is of type @a CMPSendMessagesResult* or nil if an error occurred.
 */
- (void)sendMessage:(CMPSendableMessage *)message toConversationWithID:(NSString *)conversationID completion:(void(^)(CMPResult<CMPSendMessagesResult *> *))completion NS_SWIFT_NAME(send(message:conversationID:completion:));

#pragma mark - Status

/**
 @brief Update status' for specified messages.
 @param messageIDs Ids of messages to update status' of.
 @param status The wanted status.
 @param conversationID Id of the conversation to update status' of.
 @param completion Block with a result value, the @b object returned is of type @a NSNumber* (mapping to BOOL determining success of the sent request) or nil if an error occurred.
 */
- (void)updateStatusForMessagesWithIDs:(NSArray<NSString *> *)messageIDs status:(CMPMessageDeliveryStatus)status conversationID:(NSString *)conversationID timestamp:(NSDate *)timestamp completion:(void (^)(CMPResult<NSNumber *> *))completion NS_SWIFT_NAME(updateStatus(messageIDs:status:conversationID:timestamp:completion:));

#pragma mark - Content

/**
 @brief Upload file-content (image, video, audio) to Comapi servers and retrieve an URL to attach to a new message.
 @param content Object containing content related data.
 @param folder Folder to which to upload the file-content.
 @param completion Block with a result value, the @b object returned is of type @a CMPContentUploadResult* or nil if an error occurred.
 */
- (void)uploadContent:(CMPContentData *)content folder:(nullable NSString *)folder completion:(void(^)(CMPResult<CMPContentUploadResult *> *))completion NS_SWIFT_NAME(upload(content:folder:completion:));

/**
 @brief Upload file-content (image, video, audio) to Comapi servers and retrieve an URL to attach to a new message.
 @param url URL pointing to the file being uploaded.
 @param filename Name for the file being uploaded.
 @param type MIME type of the file being uploaded.
 @param folder Folder to which to upload the file-content.
 @param completion Block with a result value, the @b object returned is of type @a CMPContentUploadResult* or nil if an error occurred.
 */
- (void)uploadUrl:(NSURL *)url filename:(NSString *)filename type:(NSString *)type folder:(nullable NSString *)folder completion:(void(^)(CMPResult<CMPContentUploadResult *> *))completion NS_SWIFT_NAME(upload(url:filename:type:folder:completion:));

/**
 @brief Upload file-content (image, video, audio) to Comapi servers and retrieve an URL to attach to a new message.
 @param data Binary data of the content being uploaded.
 @param filename Name for the file being uploaded.
 @param type MIME type of the file being uploaded.
 @param folder Folder to which to upload the file-content.
 @param completion Block with a result value, the @b object returned is of type @a CMPContentUploadResult* or nil if an error occurred.
 */
- (void)uploadData:(NSData *)data filename:(NSString *)filename type:(NSString *)type folder:(nullable NSString *)folder completion:(void(^)(CMPResult<CMPContentUploadResult *> *))completion NS_SWIFT_NAME(upload(data:filename:type:folder:completion:));


@end

/**
 @brief Messaging related Comapi services.
 */
NS_SWIFT_NAME(MessagingService)
@interface CMPMessagingService : CMPBaseService <CMPMessagingServiceable>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
