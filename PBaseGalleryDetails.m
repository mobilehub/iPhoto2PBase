//
//  PBaseUpdateGallery.m
//
//  Created by Scott Andrew on 2006-07-05.
//  Copyright (c) 2006 New Wave Digital Media. All rights reserved.
//

#import "PBaseGalleryDetails.h"
#import "PBGallery.h"
#import "PBaseConstants.h"
#import "NSError_Extension.h"

@implementation PBaseGalleryDetails

-(void)setGalleryDetails:(PBGallery*)gallery forUser:(NSString*)userName
{
	// ok we need to send a nice command to update our gallery.....
	NSString* url = [NSString stringWithFormat:@"%@%@/%@", pbaseUpload, userName, [gallery name]];
	
	// lets create our request.
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSError* error;
	NSURLResponse* response;
	
	// now we need to create our data stream. We only are setting the data needed to update our name
	// and description.. 
	NSString* data = [gallery HTMLData];
	
	//NSLog(@"%@", data);
	
	// turn on the cookies
	[request setHTTPShouldHandleCookies:YES];

	// wew ant to post the data.
	[request setHTTPMethod:@"POST"];
	
	// we want to mark this as with the proper data formatting.. 
	[request addValue:pbasePostHeader forHTTPHeaderField:@"Content-Type"];
	
	// allocate our data.
	NSData* body = [NSData dataWithData:[data dataUsingEncoding:NSASCIIStringEncoding]];
	
	// set the body of our request.. 
	[request setHTTPBody:body];

	[self sendRequest:request];
}

- (NSError*)parseRecievedData:(NSData*)data
{
	NSError* error = nil;
	NSError* xmlError = nil;
	int err = SERVER_SUCCESS;
	NSString* stringData = [[NSString alloc]initWithData:data encoding:NSISOLatin1StringEncoding];
	NSString* successMsg = @"//font[text()=\"Updated gallery.\"]";
	NSArray* foundNodes = nil;
	NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithData:[stringData dataUsingEncoding:NSUTF8StringEncoding] options:NSXMLDocumentTidyHTML error:&xmlError] autorelease];
	
	// lets temporarily spit out the XML..
	//NSLog ([xmlDoc XMLString]);
	
	if (xmlDoc != nil)
	{
		foundNodes = [xmlDoc nodesForXPath:successMsg error:&xmlError];
		
		if ([foundNodes count] == 0)
			err = SERVER_COULD_NOT_UPDATE_GALLERY;
	}
	
	if (err != SERVER_SUCCESS)
		error = [NSError withErrorCode:[NSBundle bundleForClass:[self class]] code:err argument:nil];

	return error;
}

@end
