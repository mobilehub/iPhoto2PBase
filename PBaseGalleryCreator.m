//
//  PBaseGalleryCreator.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 7/4/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import "PBaseGalleryCreator.h"
#import "PBGallery.h"
#import "PBaseConstants.h"
#import "NSError_Extension.h"

@implementation PBaseGalleryCreator

-(id)initWithDelegate:(id)aDelegate
{
	if (self = [super initWithDelegate:aDelegate])
		galleryToBeCreated = nil;
		
	return self;
}

-(void) createGallery:(PBGallery*)galleryToCreate forUser:(NSString*)user
{

	PBGallery* parentGallery = [galleryToCreate parentGallery];
	
	// we want to create the galler lets do some work to the gallery name that will create a 
	// valid gallery..
	NSString* galleryUploadCommand = [NSString stringWithFormat:createGalleryLineData, 
									  [parentGallery number],
									  [galleryToCreate name],
									  [parentGallery isChild] ? @"Y" : @"N"];
	
	//NSLog(@"%@", galleryUploadCommand);
	
	NSString* url = [NSString stringWithFormat:@"%@%@/%@", pbaseUpload, user, [parentGallery name]];
	
	//NSLog(@"%@", url);
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSError* error;
	NSURLResponse* response; 
	
	galleryToBeCreated = [galleryToCreate retain];

	// turn on the cookies
	[request setHTTPShouldHandleCookies:YES];

	// wew ant to post the data.
	[request setHTTPMethod:@"POST"];
	
	// we want to mark this as with the proper data formatting.. 
	[request addValue:pbasePostHeader forHTTPHeaderField:@"Content-Type"];
	
	// allocate our data.
	NSData* body = [NSData dataWithData:[galleryUploadCommand dataUsingEncoding:NSASCIIStringEncoding]];
		
	// set the body of our request.. 
	[request setHTTPBody:body];
	
	[self sendRequest:request];
	
}

-(NSError*) parseRecievedData:(NSData*)data
{
	NSError* error = nil;
	NSError* xmlError = nil;
	int err = SERVER_SUCCESS;
	NSString* stringData = [[NSString alloc]initWithData:data encoding:NSISOLatin1StringEncoding];
	NSString* successMsg = @"//font[text()=\"Created new gallery %@.\"]";
	NSString* alreadyExistMsg = @"//font[text()=\"You already have a gallery with that name.\"]";
	NSArray* foundNodes = nil;
	NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithData:[stringData dataUsingEncoding:NSUTF8StringEncoding] options:NSXMLDocumentTidyHTML error:&xmlError] autorelease];
	
	// lets temporarily spit out the XML..
	//NSLog ([xmlDoc XMLString]);
	
	if (xmlDoc != nil)
	{
		// lets see got the "already exists" error.
		foundNodes = [xmlDoc nodesForXPath:alreadyExistMsg error:&xmlError];
		
		// if so set the error.
		if ([foundNodes count] > 0)
			err = SERVER_GALLERY_ALREADY_EXISTS;
		
		// if we didn't find it (our error still is success) then see
		// if we succeeded.
		if (err == SERVER_SUCCESS)
		{
			NSString* xmlSucess = [NSString stringWithFormat:successMsg, [galleryToBeCreated name]];
			
			foundNodes = [xmlDoc nodesForXPath:xmlSucess error:&xmlError];
		}	
		
		// if we didn't find a succeed message then we 
		// didn't create the gallery and report an error.
		if ([foundNodes count] == 0)
			err = SERVER_COULD_NO_CREATE_GALLERY;
	}
	else
		error = xmlError;

	if (err != SERVER_SUCCESS)
		error = [NSError withErrorCode:[NSBundle bundleForClass:[self class]] code:err argument:nil];

	return error;

}

-(void)dealloc
{
	[galleryToBeCreated release];
	
	[super dealloc];
}

@end