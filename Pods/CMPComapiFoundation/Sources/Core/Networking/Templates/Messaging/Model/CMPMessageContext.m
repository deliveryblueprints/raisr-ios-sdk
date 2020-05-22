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

#import "CMPMessageContext.h"
#import "NSString+CMPUtility.h"
#import "NSDate+CMPUtility.h"

@implementation CMPMessageContext

- (instancetype)initWithConversationID:(NSString *)conversationID from:(CMPMessageParticipant *)from sentBy:(NSString *)sentBy sentOn:(NSDate *)sentOn {
    self = [super init];
    
    if (self) {
        self.conversationID = conversationID;
        self.from = from;
        self.sentBy = sentBy;
        self.sentOn = sentOn;
    }
    
    return self;
}

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.conversationID forKey:@"conversationId"];
    [dict setValue:self.sentBy forKey:@"sentBy"];
    [dict setValue:[self.sentOn ISO8061String] forKey:@"sentOn"];
    [dict setValue:[self.from json] forKey:@"from"];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"conversationId"] && [JSON[@"conversationId"] isKindOfClass:NSString.class]) {
            self.conversationID = JSON[@"conversationId"];
        }
        if (JSON[@"sentBy"] && [JSON[@"sentBy"] isKindOfClass:NSString.class]) {
            self.sentBy = JSON[@"sentBy"];
        }
        if (JSON[@"sentOn"] && [JSON[@"sentOn"] isKindOfClass:NSString.class]) {
            self.sentOn = [(NSString *)JSON[@"sentOn"] asDate];
        }
        if (JSON[@"from"] && [JSON[@"from"] isKindOfClass:NSDictionary.class]) {
            self.from = [[CMPMessageParticipant alloc] initWithJSON:JSON[@"from"]];
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
    return [[CMPMessageContext alloc] initWithJSON:json];
}

@end
