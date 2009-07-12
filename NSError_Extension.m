//
//  NSError_Extension.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 6/20/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import "NSError_Extension.h"
#import "utils.h"

@implementation NSError(ServerExtension)

+(id) withErrorCode:(NSBundle*)bundle code:(int)err argument:(NSString*)arg;
{
	NSError* error = [[NSError alloc] initWithErrorCode:bundle code:err argument:arg];
	
	return [error autorelease];
}

-(id) initWithErrorCode:(NSBundle*)bundle code:(int)err argument:(NSString*)arg;
{	
	if ((self = [super init]) && err != SERVER_SUCCESS)
	{
	//	NSBundle* bundle = [NSBundle bundleForClass:[self class]];
		NSMutableDictionary* data = [NSMutableDictionary dictionary];
		NSString* stringID = [NSString stringWithFormat:@"%d", err];
		NSString* error = [bundle localizedStringForKey:stringID value:@"Invalid string" table:nil];
		NSString* pN = [bundle localizedStringForKey:@"4001" value:@"" table:nil];
		
		NSString* errString;
		
		if  (arg != NULL)
			errString = [NSString stringWithFormat:error, arg];
		else
			errString = error;
		
		// stuff our error string in to the NSLocalaizedDescrtionKey... 
		[data setObject:errString forKey:NSLocalizedDescriptionKey];
		
		return [self initWithDomain:@"PBaseServer" code:err userInfo:data];
		
	}
	
}

@end
