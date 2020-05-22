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

#import "CMPGetMessagesResult.h"

@implementation CMPGetMessagesResult

- (instancetype)initWithLatestEventID:(NSNumber *)latestEventID earliestEventID:(NSNumber *)earliestEventID messages:(NSArray<CMPMessage *> *)messages orphanedEvents:(NSArray<CMPOrphanedEvent *> *)orphanedEvents {
    self = [super init];
    
    if (self) {
        self.latestEventID = latestEventID;
        self.earliestEventID = earliestEventID;
        self.messages = messages;
        self.orphanedEvents = orphanedEvents;
    }
    
    return self;
}

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.latestEventID forKey:@"latestEventId"];
    [dict setValue:self.earliestEventID forKey:@"earliestEventId"];
    NSMutableArray<NSDictionary<NSString *, id> *> *messages = [NSMutableArray new];
    [self.messages enumerateObjectsUsingBlock:^(CMPMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [messages addObject:[obj json]];
    }];
    [dict setValue:messages forKey:@"messages"];
    NSMutableArray<NSDictionary<NSString *, id> *> *events = [NSMutableArray new];
    [self.orphanedEvents enumerateObjectsUsingBlock:^(CMPOrphanedEvent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [events addObject:[obj json]];
    }];
    [dict setValue:events forKey:@"orphanedEvents"];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"latestEventId"] && [JSON[@"latestEventId"] isKindOfClass:NSNumber.class]) {
            self.latestEventID = JSON[@"latestEventId"];
        }
        if (JSON[@"earliestEventId"] && [JSON[@"earliestEventId"] isKindOfClass:NSNumber.class]) {
            self.earliestEventID = JSON[@"earliestEventId"];
        }
        if (JSON[@"messages"] && [JSON[@"messages"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPMessage *> *messages = [NSMutableArray new];
            NSArray<NSDictionary<NSString *, id> *> *objects = JSON[@"messages"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [messages addObject:[[CMPMessage alloc] initWithJSON:obj]];
            }];
            self.messages = messages;
        }
        if (JSON[@"orphanedEvents"] && [JSON[@"orphanedEvents"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPOrphanedEvent *> *events = [NSMutableArray new];
            NSArray<NSDictionary<NSString *, id> *> *objects = JSON[@"orphanedEvents"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [events addObject:[[CMPOrphanedEvent alloc] initWithJSON:obj]];
            }];
            self.orphanedEvents = events;
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
    return [[CMPGetMessagesResult alloc] initWithJSON:json];
}

@end
