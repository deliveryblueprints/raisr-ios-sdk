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

#import "CMPFileDestination.h"
#import "CMPLogLevel.h"
#import "CMPLog.h"
#import "CMPConstants.h"
#import "NSDateFormatter+CMPUtility.h"

@interface CMPFileDestination ()

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation CMPFileDestination

@synthesize minimumLogLevel = _minimumLogLevel;
@synthesize dateFormatter = _dateFormatter;

- (instancetype)initWithMinimumLevel:(CMPLogLevel)minimumLevel {
    self = [super self];
    
    if(self) {
        self.minimumLogLevel = minimumLevel;
        self.dateFormatter = [NSDateFormatter iso8061Formatter];
        self.fileName = CMPLogFileName;
        self.queue = dispatch_queue_create([CMPQueueNameFileDestination UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)logItems:(NSArray<id> *)items level:(CMPLogLevel)level date:(NSDate *)date {
    if (self.minimumLogLevel > level) {
        return;
    }
    
    NSString *prefix = [NSString stringWithFormat:@"%@ %@", [CMPLogLevelRepresenter emojiRepresentationForLogLevel:level], [CMPLogLevelRepresenter textualRepresentationForLogLevel:level]];
    NSString *timeStr = [self.dateFormatter stringFromDate:date];
    NSString *message = [CMPLog stringFromItems:items separator:nil terminator:@""];
    
    NSString *logHeader = [@[prefix, timeStr] componentsJoinedByString:@" "];
    NSString *text = [CMPLog stringFromItems:@[logHeader, message] separator:nil terminator:nil];
    
    [self logToFileWithText:text];
}

- (NSString *)loggingPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *loggingPath = [NSString stringWithFormat:@"%@%@", documentsPath, self.fileName];
    if (![fileManager fileExistsAtPath:loggingPath]) {
        [fileManager createFileAtPath:loggingPath contents:nil attributes:nil];
    }
    return loggingPath;
}

- (NSFileHandle *)loggingWriteHandle {
    return [NSFileHandle fileHandleForWritingAtPath:[self loggingPath]];
}

- (NSFileHandle *)loggingReadHandle {
    return [NSFileHandle fileHandleForReadingAtPath:[self loggingPath]];
}

- (void)logToFileWithText:(NSString *)text {
    NSFileHandle *fileHandle = [self loggingWriteHandle];
    [fileHandle seekToEndOfFile];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        [fileHandle writeData:data];
    }
}

- (nullable NSData *)getFileLogs {
    NSFileHandle *fileHandle = [self loggingReadHandle];
    [fileHandle seekToFileOffset:0];
  
    NSData *data = [fileHandle readDataToEndOfFile];

    return data;
}

@end
