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

#import "NSData+CMPUtility.h"

@implementation NSData (CMPUtility)

- (instancetype)initWithInputStream:(NSInputStream *)stream {
    
    NSMutableData *data = [NSMutableData data];
    [stream open];
    NSInteger result;
    uint8_t buffer[1024];
    
    while((result = [stream read:buffer maxLength:1024]) != 0) {
        if(result > 0) {
            [data appendBytes:buffer length:result];
        } else {
            if (result < 0) {
                [NSException raise:@"STREAM_ERROR" format:@"%@", [stream streamError]];
            }
        }
    }
    
    return data;
}

- (NSString *)utf8StringValue {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    }
    NSData *prettyPrintedData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted | NSJSONReadingAllowFragments error:&error];
    if (error) {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    }
    
    return [[NSString alloc] initWithData:prettyPrintedData encoding:NSUTF8StringEncoding];
}

@end
