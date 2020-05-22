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

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CMPQueryElement) {
    CMPQueryElementEqual,
    CMPQueryElementUnequal,
    CMPQueryElementGreaterThan,
    CMPQueryElementLessThan,
    CMPQueryElementGreaterOrEqualThan,
    CMPQueryElementLessOrEqualThan,
    CMPQueryElementStartsWith,
    CMPQueryElementEndsWith,
    CMPQueryElementContains,
    CMPQueryElementInArray,
    CMPQueryElementNotInArray,
    CMPQueryElementAnd,
    CMPQueryElementBegin
} NS_SWIFT_NAME(QueryElement);

NS_SWIFT_NAME(QueryElements)
@interface CMPQueryElements: NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic) CMPQueryElement element;
@property (nonatomic, strong) NSString *value;

- (instancetype)initWithKey:(NSString *)key element:(CMPQueryElement)element value:(NSString *)value;

@end

NS_SWIFT_NAME(QueryBuilder)
@interface CMPQueryBuilder : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (NSString *)buildQueryWithElements:(NSArray<CMPQueryElements *> *)elements;

@end

NS_ASSUME_NONNULL_END
