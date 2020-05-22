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

#import "CMPProfile.h"

@implementation CMPProfile

- (instancetype)initWithID:(NSString *)ID {
    self = [super init];
    
    if (self) {
        self.id = ID;
    }
    
    return self;
}

#pragma mark - CMPJSONRepresentable

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.email forKey:@"email"];
    [dict setValue:self.firstName forKey:@"firstName"];
    [dict setValue:self.lastName forKey:@"lastName"];
    [dict setValue:self.gender forKey:@"gender"];
    [dict setValue:self.phoneNumber forKey:@"phoneNumber"];
    [dict setValue:self.phoneNumberCountryCode forKey:@"phoneNumberCountryCode"];
    [dict setValue:self.profilePicture forKey:@"profilePicture"];
    
    [self.customProperties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dict setValue:obj forKey:key];
    }];
    
    return dict;
}

#pragma mark - CMPJSONDecoding

- (instancetype)initWithJSON:(id)JSON {
    self = [super init];
    
    if (self) {
        self.customProperties = [[NSDictionary alloc] init];
        NSDictionary<NSString *, id> *dict = JSON;
        
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"id"] && [obj isKindOfClass:NSString.class]) {
                self.id = obj;
            } else if ([key isEqualToString:@"email"] && [obj isKindOfClass:NSString.class]) {
                self.email = obj;
            } else if ([key isEqualToString:@"firstName"] && [obj isKindOfClass:NSString.class]) {
                self.firstName = obj;
            } else if ([key isEqualToString:@"lastName"] && [obj isKindOfClass:NSString.class]) {
                self.lastName = obj;
            } else if ([key isEqualToString:@"gender"] && [obj isKindOfClass:NSString.class]) {
                self.gender = obj;
            } else if ([key isEqualToString:@"phoneNumber"] && [obj isKindOfClass:NSString.class]) {
                self.phoneNumber = obj;
            } else if ([key isEqualToString:@"phoneNumberCountryCode"] && [obj isKindOfClass:NSString.class]) {
                self.phoneNumberCountryCode = obj;
            } else if ([key isEqualToString:@"profilePicture"] && [obj isKindOfClass:NSString.class]) {
                self.profilePicture = [NSURL URLWithString:(NSString *)obj];
            } else {
                NSMutableDictionary<NSString *, id> *copy = [self.customProperties mutableCopy];
                [copy addEntriesFromDictionary:@{key : obj}];
                self.customProperties = [NSDictionary dictionaryWithDictionary:copy];
            }
        }];
    }

    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPProfile alloc] initWithJSON:json];
}

@end
