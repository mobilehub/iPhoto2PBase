//
//  FileUploadStream.m
//  iPhoto2PBase
//
//  Created by Scott  Andrew on 4/11/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import "FileUploadStream.h"


@implementation FileUploadStream

- (id)initWithData:(NSData *)data
{
	self = [super init];
	
	stream = [NSInputStream inputStreamWithData:data];
	
	return self;
}

- (int)read:(uint8_t *)buffer maxLength:(unsigned int)len
{
	//int nRead = [super read:buffer maxLength:len];
	int read = [stream read:buffer maxLength:len];
		
	return read;
}

- (BOOL)getBuffer:(uint8_t **)buffer length:(unsigned int *)len
 {
 return [stream getBuffer:buffer length:len];
 }
 
 - (BOOL)hasBytesAvailable
 {
	return [stream hasBytesAvailable]; 
}


-(void)open
{
	[stream open];
}

- (void)close
{
	[stream close];
}

- (id)delegate
{
	return [stream delegate];
}

- (void)setDelegate:(id)delegate
{
		[stream setDelegate:delegate];
}

- (id)propertyForKey:(NSString *)key
{
	return [stream propertyForKey:key];
}

- (BOOL)setProperty:(id)property forKey:(NSString *)key
{
	return [stream setProperty:property forKey:key];
}

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode
{
	[stream scheduleInRunLoop:aRunLoop forMode:mode];
}

- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode
{
	[stream removeFromRunLoop:aRunLoop forMode:mode];
}

- (NSStreamStatus)streamStatus
{
	return [stream streamStatus];
}

- (NSError *)streamError
{
	return [stream streamError];
}

@end
