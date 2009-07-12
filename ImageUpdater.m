//
//  ImageUpdater.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 4/5/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import "ImageUpdater.h"
#import "PBaseConstants.h"
#import "NSError_Extension.h"

@implementation ImageUpdater

-(void) updateImage:(NSURL*)url withCommand:(NSString*)command
{
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	NSError* error;
	NSURLResponse* response; 
	
	// turn on the cookies
	[request setHTTPShouldHandleCookies:YES];

	// wew ant to post the data.
	[request setHTTPMethod:@"POST"];
	
	// we want to mark this as with the proper data formatting.. 
	[request addValue:pbasePostHeader forHTTPHeaderField:@"Content-Type"];
	
	// allocate our data.
	NSData* body = [NSData dataWithData:[command dataUsingEncoding:NSASCIIStringEncoding]];
		
	// set the body of our request.. 
	[request setHTTPBody:body];
	
	[self sendRequest:request];
}

-(NSError*)parseRecievedData:(NSData*)data
{
	NSError* xmlError = nil;
	NSError* error = nil;
	NSString* stringData = [[NSString alloc]initWithData:data encoding:NSISOLatin1StringEncoding];
	NSString* successMsg = @"//font[text()=\"Updated Image\"]";
	NSArray* foundNodes = nil;
	NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithData:[stringData dataUsingEncoding:NSUTF8StringEncoding] options:NSXMLDocumentTidyHTML error:&xmlError] autorelease];
	
	// look through our doc for the success node.
	foundNodes = [xmlDoc nodesForXPath:successMsg error:&error];

	// if we didn't find any nodes then we need to go ahead and report an error.
	if ([foundNodes count] == 0)
		error = [NSError withErrorCode:[NSBundle bundleForClass:[self class]] code:SERVER_COULD_NOT_UPDATE_KEYWORDS argument:nil];
		
	return error;
}

@end
