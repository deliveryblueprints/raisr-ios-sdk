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

#import "CMPConversationMessageEvents.h"
#import "NSString+CMPUtility.h"
#import "NSDateFormatter+CMPUtility.h"
#import "CMPMessageContext.h"
#import "CMPMessagePart.h"
#import "CMPMessageAlert.h"

#import "CMPJSONDecoding.h"
#import "CMPJSONEncoding.h"
#import "CMPJSONRepresentable.h"
#import "CMPJSONConstructable.h"

#pragma mark - ConversationMessage

@implementation CMPConversationMessageEvent

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"conversationEventId"] && [JSON[@"conversationEventId"] isKindOfClass:NSNumber.class]) {
            self.conversationEventID = JSON[@"conversationEventId"];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:self.conversationEventID forKey:@"conversationEventId"];
    
    return dict;
}

@end

#pragma mark - Delivered

@implementation CMPConversationMessageEventDeliveredPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];

    if (self) {
        if (JSON[@"messageId"] && [JSON[@"messageId"] isKindOfClass:NSString.class]) {
            self.messageID = JSON[@"messageId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"timestamp"] && [JSON[@"timestamp"] isKindOfClass:NSString.class]) {
            self.timestamp = [(NSString *)JSON[@"timestamp"] asDate];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.messageID forKey:@"messageId"];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:[[NSDateFormatter comapiFormatter] stringFromDate:self.timestamp] forKey:@"timestamp"];
    
    return dict;
}

@end

@implementation CMPConversationMessageEventDelivered

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];

    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationMessageEventDeliveredPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationMessageEventDelivered alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

#pragma mark - Read

@implementation CMPConversationMessageEventReadPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"messageId"] && [JSON[@"messageId"] isKindOfClass:NSString.class]) {
            self.messageID = JSON[@"messageId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"timestamp"] && [JSON[@"timestamp"] isKindOfClass:NSString.class]) {
            self.timestamp = [(NSString *)JSON[@"timestamp"] asDate];
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.messageID forKey:@"messageId"];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:[[NSDateFormatter comapiFormatter] stringFromDate:self.timestamp] forKey:@"timestamp"];
    
    return dict;
}

@end

@implementation CMPConversationMessageEventRead

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationMessageEventReadPayload alloc] initWithJSON:JSON[@"payload"]];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationMessageEventRead alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end

#pragma mark - Sent

@implementation CMPConversationMessageEventSentPayload

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"messageId"] && [JSON[@"messageId"] isKindOfClass:NSString.class]) {
            self.messageID = JSON[@"messageId"];
        }
        if (JSON[@"metadata"] && [JSON[@"metadata"] isKindOfClass:NSDictionary.class]) {
            self.metadata = JSON[@"metadata"];
        }
        if (JSON[@"context"] && [JSON[@"context"] isKindOfClass:NSDictionary.class]) {
            self.context = [[CMPMessageContext alloc] initWithJSON:JSON[@"context"]];
        }
        if (JSON[@"alert"] && [JSON[@"alert"] isKindOfClass:NSDictionary.class]) {
            self.alert = [[CMPMessageAlert alloc] initWithJSON:JSON[@"alert"]];
        }
        if (JSON[@"parts"] && [JSON[@"parts"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPMessagePart *> *parts = [NSMutableArray new];
            NSArray<NSDictionary<NSString *, id> *> *objects = JSON[@"parts"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [parts addObject:[[CMPMessagePart alloc] initWithJSON:obj]];
            }];
            self.parts = parts;
        }
    }
    
    return self;
}

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.messageID forKey:@"messageId"];
    [dict setValue:self.metadata forKey:@"metadata"];
    [dict setValue:[self.context json] forKey:@"context"];
    [dict setValue:[self.alert json] forKey:@"alert"];
    NSMutableArray<NSDictionary<NSString *, id> *> *messages = [NSMutableArray new];
    [self.parts enumerateObjectsUsingBlock:^(CMPMessagePart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [messages addObject:[obj json]];
    }];
    [dict setValue:messages forKey:@"parts"];
    
    return dict;
}

@end

@implementation CMPConversationMessageEventSent

- (instancetype)initWithJSON:(id)JSON {
    self = [super initWithJSON:JSON];
    
    if (self) {
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPConversationMessageEventSentPayload alloc] initWithJSON:JSON[@"payload"]];
        }
        if (JSON[@"publishedOn"] && [JSON[@"publishedOn"] isKindOfClass:NSString.class]) {
            self.publishedOn = [(NSString *)JSON[@"publishedOn"] asDate];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPConversationMessageEventSent alloc] initWithJSON:json];
}

- (id)json {
    NSMutableDictionary *dict = [super json];
    [dict setValue:[self.payload json] forKey:@"payload"];
    
    return dict;
}

@end
