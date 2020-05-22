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

#import "CMPBroadcastDelegate.h"
#import "CMPLogger.h"

@interface CMPBroadcastDelegate<__covariant Delegate> ()

@property (nonatomic, strong) NSHashTable<Delegate> *delegates;

@end

@implementation CMPBroadcastDelegate

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.delegates = [NSHashTable weakObjectsHashTable];
    }
    
    return self;
}

- (void)addDelegate:(id)delegate {
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id)delegate {
    if ([self.delegates containsObject:delegate]) {
        [self.delegates removeObject:delegate];
    } else {
        logWithLevel(CMPLogLevelWarning, @"Delegate not found, returning...", nil);
    }
}

- (void)invokeDelegatesWithBlock:(void (^)(id delegate))block {
    NSEnumerator *enumerator = [self.delegates objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) {
        block(value);
    }
}

@end
