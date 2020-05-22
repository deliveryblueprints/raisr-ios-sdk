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

#import "CMPSession.h"

#import "NSString+CMPUtility.h"
#import "NSDateFormatter+CMPUtility.h"

@implementation CMPSession

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.nonce forKey:@"nonce"];
    [dict setValue:self.provider forKey:@"provider"];
    [dict setValue:[[NSDateFormatter iso8061Formatter] stringFromDate:self.expiresOn] forKey:@"expiresOn"];
    [dict setValue:self.isActive forKey:@"isActive"];
    [dict setValue:self.platform forKey:@"platform"];
    [dict setValue:self.platformVersion forKey:@"platformVersion"];
    [dict setValue:self.sdkType forKey:@"sdkType"];
    [dict setValue:self.sdkVersion forKey:@"sdkVersion"];
    [dict setValue:self.profileID forKey:@"profileId"];
    [dict setValue:self.deviceID forKey:@"deviceId"];
    [dict setValue:self.sourceIP forKey:@"sourceIp"];
    
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
        if (JSON[@"id"] != nil && [JSON[@"id"] isKindOfClass:[NSString class]]) {
            self.id = JSON[@"id"];
        }
        if (JSON[@"nonce"] != nil && [JSON[@"nonce"] isKindOfClass:[NSString class]]) {
            self.nonce = JSON[@"nonce"];
        }
        if (JSON[@"provider"] != nil && [JSON[@"provider"] isKindOfClass:[NSString class]]) {
            self.provider = JSON[@"provider"];
        }
        if (JSON[@"expiresOn"] != nil && [JSON[@"expiresOn"] isKindOfClass:[NSString class]]) {
            self.expiresOn = [(NSString *)JSON[@"expiresOn"] asDate];
        }
        if (JSON[@"isActive"] != nil && [JSON[@"isActive"] isKindOfClass:[NSNumber class]]) {
            self.isActive = JSON[@"isActive"];
        }
        if (JSON[@"deviceId"] != nil && [JSON[@"deviceId"] isKindOfClass:[NSString class]]) {
            self.deviceID = JSON[@"deviceId"];
        }
        if (JSON[@"platform"] != nil && [JSON[@"platform"] isKindOfClass:[NSString class]]) {
            self.platform = JSON[@"platform"];
        }
        if (JSON[@"platformVersion"] != nil && [JSON[@"platformVersion"] isKindOfClass:[NSString class]]) {
            self.platformVersion = JSON[@"platformVersion"];
        }
        if (JSON[@"sdkType"] != nil && [JSON[@"sdkType"] isKindOfClass:[NSString class]]) {
            self.sdkType = JSON[@"sdkType"];
        }
        if (JSON[@"sdkVersion"] != nil && [JSON[@"sdkVersion"] isKindOfClass:[NSString class]]) {
            self.sdkVersion = JSON[@"sdkVersion"];
        }
        if (JSON[@"profileId"] != nil && [JSON[@"profileId"] isKindOfClass:[NSString class]]) {
            self.profileID = JSON[@"profileId"];
        }
        if (JSON[@"sourceIp"] != nil && [JSON[@"sourceIp"] isKindOfClass:[NSString class]]) {
            self.sourceIP = JSON[@"sourceIp"];
        }
    }
    
    return self;
}

+ (instancetype)decodeWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[CMPSession alloc] initWithJSON:json];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.nonce forKey:@"nonce"];
    [aCoder encodeObject:self.provider forKey:@"provider"];
    [aCoder encodeObject:self.expiresOn forKey:@"expiresOn"];
    [aCoder encodeObject:self.deviceID forKey:@"deviceId"];
    [aCoder encodeObject:self.platform forKey:@"platform"];
    [aCoder encodeObject:self.platformVersion forKey:@"platformVersion"];
    [aCoder encodeObject:self.sdkType forKey:@"sdkType"];
    [aCoder encodeObject:self.profileID forKey:@"profileId"];
    [aCoder encodeObject:self.sourceIP forKey:@"sourceIp"];
    [aCoder encodeObject:self.isActive forKey:@"isActive"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.nonce = [aDecoder decodeObjectForKey:@"nonce"];
        self.provider = [aDecoder decodeObjectForKey:@"provider"];
        self.expiresOn = [aDecoder decodeObjectForKey:@"expiresOn"];
        self.deviceID = [aDecoder decodeObjectForKey:@"deviceId"];
        self.platform = [aDecoder decodeObjectForKey:@"platform"];
        self.platformVersion = [aDecoder decodeObjectForKey:@"platformVersion"];
        self.sdkType = [aDecoder decodeObjectForKey:@"sdkType"];
        self.profileID = [aDecoder decodeObjectForKey:@"profileId"];
        self.sourceIP = [aDecoder decodeObjectForKey:@"sourceIp"];
        self.isActive = [aDecoder decodeObjectForKey:@"isActive"];
    }
    
    return self;
}

@end

