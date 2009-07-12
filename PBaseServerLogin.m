//
//  PBaseServerLogin.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 6/19/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import "PBaseServerLogin.h"
#import "NSError_Extension.h"
#import "PBaseConstants.h"

@implementation PBaseServerLogin

-(bool)logout
{
	NSString* urlString = [[[NSString alloc]initWithFormat:@"%@%@", pbaseBaseURL, pbaseLogOut] autorelease];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	NSError* error;
	NSURLResponse* response;
	
	NSData* pData = [NSURLConnection sendSynchronousRequest:request
					 returningResponse:&response 
					 error:&error];
					 					 
	return pData != nil;
}

-(void)login:(NSString*)username password:(NSString*)password
{
	NSString* url = [NSString stringWithFormat:@"%@%@", pbaseBaseURL, pbaseLogin];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSString* bodyString = [NSString stringWithFormat:pbaseLoginData, username, password];
		
	[self logout];
	
	// turn on cookies
	[request setHTTPShouldHandleCookies:YES];
	
	// we want to post the data... 
	[request setHTTPMethod:@"POST"];
	
		// we want to mark this as with the proper data formatting.. 
	[request addValue:pbasePostHeader forHTTPHeaderField:@"Content-Type"];

	// allocate our data for our body.. 
	NSData* body = [NSData dataWithData:[bodyString dataUsingEncoding:NSASCIIStringEncoding]];
	
	[request setHTTPBody:body];
	
	[self sendRequest:request];
}


-(NSError*) parseRecievedData:(NSData*)data
{
	// we need to parse the result. see what we got back.. 
	NSError* error = nil;
	NSError* xmlError = nil;
	NSArray* foundNodes;
	int err = SERVER_SUCCESS;
	NSString* stringData = [[NSString alloc]initWithData:data encoding:NSISOLatin1StringEncoding];
	
	NSXMLDocument* doc = [[[NSXMLDocument alloc] initWithData:[stringData dataUsingEncoding:NSUTF8StringEncoding] options:NSXMLDocumentTidyHTML error:&xmlError] autorelease];

	
	if (doc != nil)
	{
		foundNodes = [doc nodesForXPath:@"//tr/td/font[text()=\"no account exists with this email or username\"]" error:&xmlError];
		
		if ([foundNodes count] != 0)
			err = SERVER_INVALID_USERNAME;

		if (err == SERVER_SUCCESS)
		{
			foundNodes = [doc nodesForXPath:@"//tr/td/font[text()=\"incorrect password\"]" error:&xmlError];
			
			if ([foundNodes count] != 0)
				err = SERVER_INVALID_PASSWORD;
		}
		
		if (err == SERVER_SUCCESS)
		{
			foundNodes = [doc nodesForXPath:@"//td[@class=\"mi\" and text()=\"Username \"]/following-sibling::td[@class=\"wb\"]" error:&error];
			
			if ([foundNodes count] > 0)
			{
				NSString* temp = [[foundNodes objectAtIndex:0] stringValue];
				int nLen = [temp length];
				
				if ([temp characterAtIndex:nLen-1] == ' ')
					loginName = [temp substringToIndex:nLen-1];
				else
					loginName = temp;
				
				
				[loginName retain];
			}
			else 
				err = SERVER_UNKNOWN_ERROR;

		}
	}
	else
		error = xmlError;

	if (err != SERVER_SUCCESS)
		error = [NSError withErrorCode:[NSBundle bundleForClass:[self class]] code:err argument:nil];
	
	return error;

}

-(NSString*)loginName
{
	return loginName;
}

-(void)dealloc
{
	
	[loginName release];
	[super dealloc];
}

@end
