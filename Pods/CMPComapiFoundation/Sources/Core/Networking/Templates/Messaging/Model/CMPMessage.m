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

#import "CMPMessage.h"

@implementation CMPMessage

-(instancetype)initWithID:(nullable NSString *)ID sentEventID:(nullable NSNumber *)sentEventID metadata:(nullable NSDictionary<NSString *, id> *)metadata context:(nullable CMPMessageContext *)context parts:(nullable NSArray<CMPMessagePart *> *)parts statusUpdates:(nullable NSDictionary<NSString *, CMPMessageStatus *> *)statusUpdates {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.sentEventID = sentEventID;
        self.metadata = metadata;
        self.context = context;
        self.parts = parts;
        self.statusUpdates = statusUpdates;
    }
    
    return self;
}

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.sentEventID forKey:@"sentEventId"];
    [dict setValue:self.metadata forKey:@"metadata"];
    [dict setValue:[self.context json] forKey:@"context"];
    NSMutableArray<NSDictionary<NSString *, id> *> *parts = [NSMutableArray new];
    [self.parts enumerateObjectsUsingBlock:^(CMPMessagePart * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parts addObject:[obj json]];
    }];
    [dict setValue:parts forKey:@"parts"];
    NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *statusUpdates = [NSMutableDictionary new];
    [self.statusUpdates enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CMPMessageStatus * _Nonnull obj, BOOL * _Nonnull stop) {
        statusUpdates[key] = [obj json];
    }];
    [dict setValue:statusUpdates forKey:@"statusUpdates"];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        if (JSON[@"id"] && [JSON[@"id"] isKindOfClass:NSString.class]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"sentEventId"] && [JSON[@"sentEventId"] isKindOfClass:NSNumber.class]) {
            self.sentEventID = JSON[@"sentEventId"];
        }
        if (JSON[@"metadata"] && [JSON[@"metadata"] isKindOfClass:NSDictionary.class]) {
            self.metadata = JSON[@"metadata"];
        }
        if (JSON[@"context"] && [JSON[@"context"] isKindOfClass:NSDictionary.class]) {
            self.context = [[CMPMessageContext alloc] initWithJSON:JSON[@"context"]];
        }
        if (JSON[@"parts"] && [JSON[@"parts"] isKindOfClass:NSArray.class]) {
            NSMutableArray<CMPMessagePart *> *parts = [NSMutableArray new];
            NSArray<NSDictionary<NSString *, id> *> *objects = JSON[@"parts"];
            [objects enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [parts addObject:[[CMPMessagePart alloc] initWithJSON:obj]];
            }];
            self.parts = [NSArray arrayWithArray:parts];
        }
        if (JSON[@"statusUpdates"] && [JSON[@"statusUpdates"] isKindOfClass:NSDictionary.class]) {
            NSMutableDictionary<NSString *, CMPMessageStatus *> *statusUpdates = [NSMutableDictionary new];
            NSDictionary<NSString *, NSDictionary<NSString *, id> *> *objects = JSON[@"statusUpdates"];
            [objects enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
                statusUpdates[key] = [[CMPMessageStatus alloc] initWithJSON:obj];
            }];
            self.statusUpdates = [NSDictionary dictionaryWithDictionary:statusUpdates];
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
    return [[CMPMessage alloc] initWithJSON:json];
}

@end
