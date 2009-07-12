//
//  FileUploadStream.h
//  iPhoto2PBase
//
//  Created by Scott  Andrew on 4/11/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FileUploadStream : NSInputStream 
{
	NSInputStream* stream;
	int totalRead;
	int totalSize;
}

- (id)initWithData:(NSData *)data;
- (void)open;
- (void)close;

- (id)delegate;
- (void)setDelegate:(id)delegate;
    // By default, a stream is its own delegate, and subclassers of NSInputStream and NSOutputStream must maintain this contract. [someStream setDelegate:nil] must restore this behavior. As usual, delegates are not retained.

- (id)propertyForKey:(NSString *)key;
- (BOOL)setProperty:(id)property forKey:(NSString *)key;

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;

- (NSStreamStatus)streamStatus;
- (NSError *)streamError;
@end
