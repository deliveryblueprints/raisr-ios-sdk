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

#import "CMPConversation.h"
#import "NSString+CMPUtility.h"
#import "NSDate+CMPUtility.h"

@implementation CMPConversation

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.name forKey:@"name"];
    [dict setValue:self.conversationDescription forKey:@"description"];
    [dict setValue:[self.roles json] forKey:@"roles"];
    [dict setValue:self.isPublic forKey:@"isPublic"];
    [dict setValue:self.latestSentEventID forKey:@"latestSentEventId"];
    [dict setValue:[self.updatedOn ISO8061String] forKey:@"updatedOn"];

    return dict;
}

- (NSData *)encode {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self json] options:0 error:&error];
    if (error) {
        return nil;
    }
    return data;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"name"] && [JSON[@"name"] isKindOfClass:NSString.class]) {
            self.name = JSON[@"name"];
        }
        if (JSON[@"description"] && [JSON[@"description"] isKindOfClass:NSString.class]) {
            self.conversationDescription = JSON[@"description"];
        }
        if (JSON[@"roles"] && [JSON[@"roles"] isKindOfClass:NSDictionary.class]) {
            self.roles = [[CMPRoles alloc] initWithJSON:JSON[@"roles"]];
        }
        if (JSON[@"isPublic"] && [JSON[@"isPublic"] isKindOfClass:NSNumber.class]) {
            self.isPublic = JSON[@"isPublic"];
        }
        if (JSON[@"latestSentEventId"] && [JSON[@"latestSentEventId"] isKindOfClass:NSNumber.class]) {
            self.latestSentEventID = JSON[@"latestSentEventId"];
        }
        if (JSON[@"_updatedOn"] && [JSON[@"_updatedOn"] isKindOfClass:NSString.class]) {
            self.updatedOn = [(NSString *)JSON[@"_updatedOn"] asDate];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    return [[CMPConversation alloc] initWithJSON:json];
}

@end
