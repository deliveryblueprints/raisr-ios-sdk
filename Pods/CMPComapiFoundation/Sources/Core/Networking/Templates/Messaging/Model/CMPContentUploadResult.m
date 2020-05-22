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

#import "CMPContentUploadResult.h"

@implementation CMPContentUploadResult

- (instancetype)initWithID:(NSString *)ID type:(NSString *)type size:(NSNumber *)size folder:(NSString *)folder url:(NSURL *)url {
    self = [super init];
    
    if (self) {
        self.id = ID;
        self.type = type;
        self.size = size;
        self.folder = folder;
        self.url = url;
    }
    
    return self;
}

#pragma mark - CMPJSONEncoding

- (id)json {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:self.id forKey:@"id"];
    [dict setValue:self.type forKey:@"type"];
    [dict setValue:self.size forKey:@"size"];
    [dict setValue:self.folder forKey:@"folder"];
    [dict setValue:[self.url absoluteString] forKey:@"url"];
    
    return dict;
}

- (nullable NSData *)encode {
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
        if (JSON[@"type"] && [JSON[@"type"] isKindOfClass:NSString.class]) {
            self.type = JSON[@"type"];
        }
        if (JSON[@"size"] && [JSON[@"size"] isKindOfClass:NSNumber.class]) {
            self.size = JSON[@"size"];
        }
        if (JSON[@"folder"] && [JSON[@"folder"] isKindOfClass:NSString.class]) {
            self.folder = JSON[@"folder"];
        }
        if (JSON[@"url"] && [JSON[@"url"] isKindOfClass:NSString.class]) {
            self.url = [NSURL URLWithString:JSON[@"url"]];
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
    return [[CMPContentUploadResult alloc] initWithJSON:json];
}

@end
