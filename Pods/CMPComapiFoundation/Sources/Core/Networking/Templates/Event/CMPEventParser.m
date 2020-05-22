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

#import "CMPEventParser.h"
#import "CMPConversationMessageEvents.h"
#import "CMPConversationEvents.h"
#import "CMPProfileEvents.h"
#import "CMPSocketEvents.h"
#import "CMPLogger.h"

@interface CMPEventParser ()

+ (CMPEventType)eventTypeForName:(NSString *)name;
+ (CMPEvent *)parseEventForJSON:(NSDictionary<NSString *, id> *)json;

@end

@implementation CMPEventParser

+ (CMPEventType)eventTypeForName:(NSString *)name {
    NSMutableArray<NSString *> *components = [NSMutableArray arrayWithArray:[name componentsSeparatedByString:@"."]];
    if ([components count] < 2) {
        //logWithLevel(CMPLogLevelError, @"Event: unrecognized event name:", name);
        return CMPEventTypeNone;
    }
    NSString *parentEventName = [[components firstObject] copy];
    NSString *childEventName = [[components lastObject] copy];
    
    if ([parentEventName isEqualToString:@"profile"]) {
        if ([childEventName isEqualToString:@"update"]) {
            return CMPEventTypeProfileUpdate;
        }
    } else if ([parentEventName isEqualToString:@"conversation"]) {
        if ([childEventName isEqualToString:@"create"]) {
            return CMPEventTypeConversationCreate;
        } else if ([childEventName isEqualToString:@"update"]) {
            return CMPEventTypeConversationUpdate;
        } else if ([childEventName isEqualToString:@"delete"]) {
            return CMPEventTypeConversationDelete;
        } else if ([childEventName isEqualToString:@"undelete"]) {
            return CMPEventTypeConversationUndelete;
        } else if ([childEventName isEqualToString:@"participantAdded"]) {
            return CMPEventTypeConversationParticipantAdded;
        } else if ([childEventName isEqualToString:@"participantRemoved"]) {
            return CMPEventTypeConversationParticipantRemoved;
        } else if ([childEventName isEqualToString:@"participantUpdated"]) {
            return CMPEventTypeConversationParticipantUpdated;
        } else if ([childEventName isEqualToString:@"participantTyping"]) {
            return CMPEventTypeConversationParticipantTyping;
        } else if ([childEventName isEqualToString:@"participantTypingOff"]) {
            return CMPEventTypeConversationParticipantTypingOff;
        }
    } else if ([parentEventName isEqualToString:@"socket"]) {
        if ([childEventName isEqualToString:@"info"]) {
            return CMPEventTypeSocketInfo;
        }
    } else if ([parentEventName isEqualToString:@"conversationMessage"]) {
        if ([childEventName isEqualToString:@"read"]) {
            return CMPEventTypeConversationMessageRead;
        } else if ([childEventName isEqualToString:@"sent"]) {
            return CMPEventTypeConversationMessageSent;
        } else if ([childEventName isEqualToString:@"delivered"]) {
            return CMPEventTypeConversationMessageDelivered;
        }
    }
    
    //logWithLevel(CMPLogLevelInfo, @"Event: unrecognized event name:", name, nil);
    
    return CMPEventTypeNone;
}

+ (CMPEvent *)parseEventForJSON:(NSDictionary<NSString *, id> *)json {
    CMPEvent *e;
    switch ([CMPEventParser eventTypeForName:json[@"name"]]) {
        case CMPEventTypeConversationCreate: {
            e = [[CMPConversationEventCreate alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationCreate;
            return e;
        }
        case CMPEventTypeConversationUpdate: {
            e = [[CMPConversationEventUpdate alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationUpdate;
            return e;
        }
        case CMPEventTypeConversationDelete: {
            e = [[CMPConversationEventDelete alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationDelete;
            return e;
        }
        case CMPEventTypeConversationUndelete: {
            e = [[CMPConversationEventUndelete alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationUndelete;
            return e;
        }
        case CMPEventTypeConversationParticipantAdded: {
            e = [[CMPConversationEventParticipantAdded alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationParticipantAdded;
            return e;
        }
        case CMPEventTypeConversationParticipantRemoved: {
            e = [[CMPConversationEventParticipantRemoved alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationParticipantRemoved;
            return e;
        }
        case CMPEventTypeConversationParticipantUpdated: {
            e = [[CMPConversationEventParticipantUpdated alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationParticipantUpdated;
            return e;
        }
        case CMPEventTypeConversationParticipantTyping: {
            e = [[CMPConversationEventParticipantTyping alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationParticipantTyping;
            return e;
        }
        case CMPEventTypeConversationParticipantTypingOff: {
            e = [[CMPConversationEventParticipantTypingOff alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationParticipantTypingOff;
            return e;
        }
        case CMPEventTypeSocketInfo: {
            e = [[CMPSocketEventInfo alloc] initWithJSON:json];
            e.type = CMPEventTypeSocketInfo;
            return e;
        }
        case CMPEventTypeProfileUpdate: {
            e = [[CMPProfileEventUpdate alloc] initWithJSON:json];
            e.type = CMPEventTypeProfileUpdate;
            return e;
        }
        case CMPEventTypeConversationMessageDelivered: {
            e = [[CMPConversationMessageEventDelivered alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationMessageDelivered;
            return e;
        }
        case CMPEventTypeConversationMessageSent: {
            e = [[CMPConversationMessageEventSent alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationMessageSent;
            return e;
        }
        case CMPEventTypeConversationMessageRead: {
            e = [[CMPConversationMessageEventRead alloc] initWithJSON:json];
            e.type = CMPEventTypeConversationMessageRead;
            return e;
        }
        case CMPEventTypeNone:
            return nil;
    }
}

+ (CMPEvent *)parseEventForData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        logWithLevel(CMPLogLevelError, @"Event: parsing error:", error.localizedDescription);
        return nil;
    }
    if ([json isKindOfClass:NSDictionary.class]) {
        CMPEvent *e = [CMPEventParser parseEventForJSON:json];
        return e;
    }
    
    logWithLevel(CMPLogLevelError, @"Event: expected type: \nNSDictionary\n, got:", [json class]);
    return nil;
}

+ (NSArray<CMPEvent *> *)parseEventsForData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        logWithLevel(CMPLogLevelError, @"Event: parsing error:", error.localizedDescription);
        return @[];
    }
    NSMutableArray<CMPEvent *> *parsedEvents = [NSMutableArray new];
    if ([json isKindOfClass:NSArray.class]) {
        NSArray<NSDictionary<NSString *, id> *> *events = json;
        [events enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull json, NSUInteger idx, BOOL * _Nonnull stop) {
            CMPEvent *e = [CMPEventParser parseEventForJSON:json];
            if (e) {
                [parsedEvents addObject:e];
            }
        }];
    } else {
        logWithLevel(CMPLogLevelError, @"Event: expected type: \nNSArray\n, got:", [json class]);
    }
    
    return [NSArray arrayWithArray:parsedEvents];
}

@end
