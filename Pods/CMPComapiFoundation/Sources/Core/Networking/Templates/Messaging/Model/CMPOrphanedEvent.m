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

#import "CMPOrphanedEvent.h"
#import "NSString+CMPUtility.h"

@implementation CMPOrphanedEventPayload

- (instancetype)initWithProfileID:(NSString *)profileID messageID:(NSString *)messageID conversationID:(NSString *)conversationID isPublicConversation:(NSNumber *)isPublicConversation timestamp:(NSDate *)timestamp {
    self = [super init];
    
    if (self) {
        self.profileID = profileID;
        self.messageID = messageID;
        self.conversationID = conversationID;
        self.isPublicConversation = isPublicConversation;
        self.timestamp = timestamp;
    }
    
    return self;
}

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:self.messageID forKey:@"messageId"];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    [dict setValue:self.isPublicConversation forKey:@"isPublicConversation"];
    [dict setValue:self.timestamp forKey:@"timestamp"];
    return dict;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"messageId"] && [JSON[@"messageId"] isKindOfClass:NSString.class]) {
            self.messageID = JSON[@"messageId"];
        }
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"isPublicConversation"] && [JSON[@"isPublicConversation"] isKindOfClass:NSNumber.class]) {
            self.isPublicConversation = JSON[@"isPublicConversation"];
        }
        if (JSON[@"timestamp"] && [JSON[@"timestamp"] isKindOfClass:NSString.class]) {
            self.timestamp = [(NSString *)JSON[@"timestamp"] asDate];
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
    return [[CMPOrphanedEventPayload alloc] initWithJSON:json];
}

@end

@implementation CMPOrphanedEventData

- (instancetype)initWithName:(NSString *)name eventID:(NSString *)eventID profileID:(NSString *)profileID payload:(CMPOrphanedEventPayload *)payload {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.eventID = eventID;
        self.profileID = profileID;
        self.payload = payload;
    }
    
    return self;
}

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.eventID forKey:@"eventId"];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:[self.payload json] forKey:@"payload"];
    return dict;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"eventId"] && [JSON[@"eventId"] isKindOfClass:NSString.class]) {
            self.eventID = JSON[@"eventId"];
        }
        if (JSON[@"profileId"] && [JSON[@"profileId"] isKindOfClass:NSString.class]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"payload"] && [JSON[@"payload"] isKindOfClass:NSDictionary.class]) {
            self.payload = [[CMPOrphanedEventPayload alloc] initWithJSON:JSON[@"payload"]];
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
    return [[CMPOrphanedEventData alloc] initWithJSON:json];
}

@end

@implementation CMPOrphanedEvent

- (instancetype)initWithID:(NSNumber *)ID data:(CMPOrphanedEventData *)data {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.data = data;
    }
    
    return self;
}

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:[self.data json] forKey:@"data"];
    return dict;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSNumber.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"data"] && [JSON[@"data"] isKindOfClass:NSDictionary.class]) {
            self.data = [[CMPOrphanedEventData alloc] initWithJSON:JSON[@"data"]];
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
    return [[CMPOrphanedEvent alloc] initWithJSON:json];
}

@end
