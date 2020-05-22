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

#import "CMPQueryBuilder.h"

@implementation CMPQueryElements

- (instancetype)initWithKey:(NSString *)key element:(CMPQueryElement)element value:(NSString *)value {
    self = [super init];
    
    if (self) {
        self.key = key;
        self.element = element;
        self.value = value;
    }
    
    return self;
}

@end

@implementation CMPQueryBuilder

+ (NSString *)valueForQueryElement:(CMPQueryElement)element {
    switch (element) {
        case CMPQueryElementEqual:
            return @"=";
        case CMPQueryElementUnequal:
            return @"!=";
        case CMPQueryElementGreaterThan:
            return @"=>";
        case CMPQueryElementLessThan:
            return @"=<";
        case CMPQueryElementGreaterOrEqualThan:
            return @"=>=";
        case CMPQueryElementLessOrEqualThan:
            return @"=<=";
        case CMPQueryElementStartsWith:
            return @"=^";
        case CMPQueryElementEndsWith:
            return @"=$";
        case CMPQueryElementContains:
            return @"=~";
        case CMPQueryElementInArray:
            return @"[]=";
        case CMPQueryElementNotInArray:
            return @"[]=!";
        case CMPQueryElementAnd:
            return @"&";
        case CMPQueryElementBegin:
            return @"?";
    }
}

+ (NSString *)buildQueryWithElements:(NSArray<CMPQueryElements *> *)elements {
    __block NSString *query = @"";
    
    [elements enumerateObjectsUsingBlock:^(CMPQueryElements * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *begin = ![query isEqualToString:@""] ? [CMPQueryBuilder valueForQueryElement:CMPQueryElementAnd] : [CMPQueryBuilder valueForQueryElement:CMPQueryElementBegin];
        query = [query stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", begin, obj.key, [CMPQueryBuilder valueForQueryElement:obj.element], obj.value.description]];
    }];
    
    return query;
}

@end
