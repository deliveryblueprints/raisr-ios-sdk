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

#import "CMPMessagingService.h"

#import "CMPEvent.h"
#import "CMPAPIConfiguration.h"
#import "CMPRequestManager.h"
#import "CMPConversationParticipant.h"
#import "CMPConversation.h"
#import "CMPConversationScope.h"
#import "CMPNewConversation.h"
#import "CMPConversationUpdate.h"
#import "CMPMessageDeliveryStatus.h"
#import "CMPMessagestatusUpdate.h"
#import "CMPGetMessagesResult.h"
#import "CMPSendMessagesResult.h"
#import "CMPSendableMessage.h"
#import "CMPContentData.h"
#import "CMPContentUploadResult.h"
#import "CMPEventQueryTemplate.h"
#import "CMPGetParticipantsTemplate.h"
#import "CMPAddParticipantsTemplate.h"
#import "CMPRemoveParticipantsTemplate.h"
#import "CMPParticipantTypingTemplate.h"
#import "CMPParticipantTypingOffTemplate.h"
#import "CMPGetConversationTemplate.h"
#import "CMPGetConversationsTemplate.h"
#import "CMPAddConversationTemplate.h"
#import "CMPUpdateConversationTemplate.h"
#import "CMPDeleteConversationTemplate.h"
#import "CMPGetMessagesTemplate.h"
#import "CMPSendMessagesTemplate.h"
#import "CMPSendStatusUpdateTemplate.h"
#import "CMPContentUploadTemplate.h"

@implementation CMPMessagingService

#pragma mark - Events

- (void)queryEventsWithConversationID:(NSString *)conversationID limit:(NSInteger)limit from:(NSInteger)from completion:(void (^)(CMPResult<NSArray<CMPEvent *> *> *))completion {
    CMPEventQueryTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPEventQueryTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID from:from limit:limit token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSArray<CMPEvent *> *> * result) {
        completion(result);
    }];
}

- (void)queryEventsWithConversationID:(NSString *)conversationID completion:(void (^)(CMPResult<NSArray<CMPEvent *> *> * _Nonnull))completion {
    [self queryEventsWithConversationID:conversationID limit:100 from:0 completion:completion];
}

- (void)queryEventsWithConversationID:(NSString *)conversationID limit:(NSInteger)limit completion:(void (^)(CMPResult<NSArray<CMPEvent *> *> * _Nonnull))completion {
    [self queryEventsWithConversationID:conversationID limit:limit from:0 completion:completion];
}

- (void)queryEventsWithConversationID:(NSString *)conversationID from:(NSInteger)from completion:(void (^)(CMPResult<NSArray<CMPEvent *> *> * _Nonnull))completion {
    [self queryEventsWithConversationID:conversationID limit:100 from:from completion:completion];
}

#pragma mark - ConversationParticipants

- (void)getParticipantsWithConversationID:(NSString *)conversationID completion:(void(^)(CMPResult<NSArray<CMPConversationParticipant *> *> *))completion {
    CMPGetParticipantsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetParticipantsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSArray<CMPConversationParticipant *> *> * result) {
        completion(result);
    }];
}

- (void)addParticipantsWithConversationID:(nonnull NSString *)conversationID participants:(nonnull NSArray<CMPConversationParticipant *> *)participants completion:(nonnull void (^)(CMPResult<NSNumber *> *))completion {
    CMPAddParticipantsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPAddParticipantsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID participants:participants token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSNumber *> * result) {
        completion(result);
    }];
}

- (void)removeParticipantsWithConversationID:(nonnull NSString *)conversationID participants:(nonnull NSArray<CMPConversationParticipant *> *)participants completion:(nonnull void (^)(CMPResult<NSNumber *> *))completion {
    CMPRemoveParticipantsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPRemoveParticipantsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID participants:participants token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSNumber *> * result) {
        completion(result);
    }];
}

- (void)participantIsTypingWithConversationID:(NSString *)conversationID isTyping:(BOOL)isTyping completion:(void (^)(CMPResult<NSNumber *> *))completion {
    if (isTyping) {
        CMPParticipantTypingTemplate *(^builder)(NSString *) = ^(NSString *token) {
            return [[CMPParticipantTypingTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID token:token];
        };
        [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSNumber *> * result) {
            completion(result);
        }];
    } else {
        CMPParticipantTypingOffTemplate *(^builder)(NSString *) = ^(NSString *token) {
            return [[CMPParticipantTypingOffTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID token:token];
        };
        [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSNumber *> * result) {
            completion(result);
        }];
    }
}

#pragma mark - Conversation

- (void)addConversationWithConversation:(nonnull CMPNewConversation *)conversation completion:(nonnull void (^)(CMPResult<CMPConversation *> *))completion {
    CMPAddConversationTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPAddConversationTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversation:conversation token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPConversation *> * result) {
        completion(result);
    }];
}


- (void)deleteConversationWithConversationID:(nonnull NSString *)conversationID eTag:(nullable NSString *)eTag completion:(nonnull void (^)(CMPResult<NSNumber *> *))completion {
    CMPDeleteConversationTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPDeleteConversationTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID eTag:eTag token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSNumber *> * result) {
        completion(result);
    }];
}


- (void)getConversationWithConversationID:(nonnull NSString *)conversationID completion:(nonnull void (^)(CMPResult<CMPConversation *> *))completion {
    CMPGetConversationTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetConversationTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPConversation *> * result) {
        completion(result);
    }];
}


- (void)getConversationsWithProfileID:(NSString *)profileID isPublic:(BOOL)isPublic completion:(void(^)(CMPResult<NSArray<CMPConversation *> *> *))completion {
    CMPGetConversationsTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetConversationsTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID profileID:profileID scope:isPublic ? CMPConversationScopePublic : CMPConversationScopeParticipant token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSArray<CMPConversation *> *> * result) {
        completion(result);
    }];
}


- (void)updateConversationWithConversationID:(nonnull NSString *)conversationID conversation:(nonnull CMPConversationUpdate *)conversation eTag:(nullable NSString *)eTag completion:(nonnull void (^)(CMPResult<CMPConversation *> *))completion {
    CMPUpdateConversationTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPUpdateConversationTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID eTag:eTag conversation:conversation token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPConversation *> * result) {
        completion(result);
    }];
}

#pragma mark - Messages

- (void)getMessagesWithConversationID:(NSString *)conversationID limit:(NSInteger)limit from:(NSInteger)from completion:(void (^)(CMPResult<CMPGetMessagesResult *> *))completion {
    CMPGetMessagesTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPGetMessagesTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID from:from limit:limit token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPGetMessagesResult *> * result) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"context.sentOn" ascending:YES];
        result.object.messages = [result.object.messages sortedArrayUsingDescriptors:@[sortDescriptor]];
        completion(result);
    }];
}

- (void)getMessagesWithConversationID:(NSString *)conversationID completion:(void (^)(CMPResult<CMPGetMessagesResult *> * _Nonnull))completion {
    [self getMessagesWithConversationID:conversationID limit:100 from:0 completion:completion];
}

- (void)getMessagesWithConversationID:(NSString *)conversationID limit:(NSInteger)limit completion:(void (^)(CMPResult<CMPGetMessagesResult *> * _Nonnull))completion {
    [self getMessagesWithConversationID:conversationID limit:limit from:0 completion:completion];
}

- (void)getMessagesWithConversationID:(NSString *)conversationID from:(NSInteger)from completion:(void (^)(CMPResult<CMPGetMessagesResult *> * _Nonnull))completion {
    [self getMessagesWithConversationID:conversationID limit:100 from:from completion:completion];
}

- (void)sendMessage:(CMPSendableMessage *)message toConversationWithID:(NSString *)conversationID completion:(void (^)(CMPResult<CMPSendMessagesResult * > *))completion {
    CMPSendMessagesTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPSendMessagesTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID message:message token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPSendMessagesResult *> * result) {
        completion(result);
    }];
}

#pragma mark - Status

- (void)updateStatusForMessagesWithIDs:(NSArray<NSString *> *)messageIDs status:(CMPMessageDeliveryStatus)status conversationID:(NSString *)conversationID timestamp:(NSDate *)timestamp completion:(void (^)(CMPResult<NSNumber *> *))completion {
    CMPSendStatusUpdateTemplate *(^builder)(NSString *) = ^(NSString *token) {
        CMPMessageStatusUpdate *statusUpdate = [[CMPMessageStatusUpdate alloc] initWithStatus:status timestamp:timestamp messageIDs:messageIDs];
        return [[CMPSendStatusUpdateTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID conversationID:conversationID token:token statusUpdates:@[statusUpdate]];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<NSNumber *> * result) {
        completion(result);
    }];
}

#pragma mark - Content

- (void)uploadContent:(CMPContentData *)content folder:(NSString *)folder completion:(void (^)(CMPResult<CMPContentUploadResult *> *))completion {
    CMPContentUploadTemplate *(^builder)(NSString *) = ^(NSString *token) {
        return [[CMPContentUploadTemplate alloc] initWithScheme:self.apiConfiguration.scheme host:self.apiConfiguration.host port:self.apiConfiguration.port apiSpaceID:self.apiSpaceID content:content folder:folder token:token];
    };
    
    [self.requestManager performUsingTemplateBuilder:builder completion:^(CMPResult<CMPContentUploadResult *> * result) {
        completion(result);
    }];
}

- (void)uploadUrl:(NSURL *)url filename:(NSString *)filename type:(NSString *)type folder:(NSString *)folder completion:(void (^)(CMPResult<CMPContentUploadResult *> *))completion {
    CMPContentData *content = [[CMPContentData alloc] initWithUrl:url type:type name:filename];
    [self uploadContent:content folder:folder completion:completion];
}

- (void)uploadData:(NSData *)data filename:(NSString *)filename type:(NSString *)type folder:(NSString *)folder completion:(void (^)(CMPResult<CMPContentUploadResult *> *))completion {
    CMPContentData *content = [[CMPContentData alloc] initWithData:data type:type name:filename];
    [self uploadContent:content folder:folder completion:completion];
}

@end
