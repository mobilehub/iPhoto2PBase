//
//  ImageOnlineData.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 4/4/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import "ImageOnlineData.h"
#import "PBaseConstants.h"
#import "Utils.h"

@implementation ImageOnlineData

-(void) readImageData:(NSURL*)url
{	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	
	// turn on the cookies
	[request setHTTPShouldHandleCookies:YES];
	
	[self sendRequest:request];	
}


-(NSError*) parseRecievedData:(NSData*)data
{
	NSError* error = nil;
	NSError* xmlError = nil;
	//int err = SERVER_SUCCESS;
	NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyHTML error:&xmlError] autorelease];

	////NSLog(@"edit data \r\n\r\n%@", [xmlDoc XMLString]);
	
	caption = [[self getTextAreaText:xmlDoc forField:@"caption"] retain];
	title = [[self getInputValue:xmlDoc forField:@"title"] retain];
	shotDate = [[self getInputValue:xmlDoc forField:@"shot_date"] retain];
	cameraBodyID = [[self getSelectedOptionID:xmlDoc forField:@"camera_body_id"] retain];
	
	if ([cameraBodyID length] == 0)
		cameraBody = [[self getInputValue:xmlDoc forField:@"camera_body"] retain];
	
	cameraLensID = [[self getSelectedOptionID:xmlDoc forField:@"camera_lens_id"] retain];
	
	if ([cameraLensID length] == 0)
		cameraLens = [[self getInputValue:xmlDoc forField:@"camera_lens"] retain];
	
	description = [[self getTextAreaText:xmlDoc forField:@"description"] retain];
	
	return nil;

}

-(NSString*) getInputValue:(NSXMLDocument*)doc forField:(NSString*)field
{
	NSString* path = [NSString stringWithFormat:@"//input[@name=\"%@\"]", field];
	NSError* xmlError;
	NSArray* foundNodes = [doc nodesForXPath:path error:&xmlError];
	NSString* returnValue = @"";
	
	if ([foundNodes count] > 0)
	{
		NSXMLElement* inputNode = [foundNodes objectAtIndex:0];	
		NSXMLNode* valueAttribute = [inputNode attributeForName:@"value"];
	
		if (valueAttribute != nil)
			returnValue = [valueAttribute stringValue];
	}
	
	return returnValue;
}


-(NSString*) getSelectedOptionID:(NSXMLDocument*)doc forField:(NSString*)field
{
	NSString* path = [NSString stringWithFormat:@"//select[@name=\"%@\"]/option[@selected=\"selected\"]", field];
	NSError* xmlError;
	NSArray* foundNodes = [doc nodesForXPath:path error:&xmlError];
	NSString* returnValue = @"";
	
	if ([foundNodes count] > 0)
	{
		NSXMLElement* selectedNode = [foundNodes objectAtIndex:0];	
		NSXMLNode* valueAttribute = [selectedNode attributeForName:@"value"];
	
		if (valueAttribute != nil)
			returnValue = [valueAttribute stringValue];		
	}
	
	return returnValue;
}

-(NSString*) getTextAreaText:(NSXMLDocument*)doc forField:(NSString*)field
{
	NSString* path = [NSString stringWithFormat:@"//textarea[@name=\"%@\"]", field];
	NSError* xmlError;
	NSArray* foundNodes = [doc nodesForXPath:path error:&xmlError];
	NSString* returnValue = @"";
	
	if ([foundNodes count] > 0)
	{
		NSXMLElement* selectedNode = [foundNodes objectAtIndex:0];	
	
		if (selectedNode != nil)
			returnValue = [selectedNode stringValue];		
	}
	
	return returnValue;
}

-(NSString*) updateStringWithKeywords:(NSString*)keywords
{
	NSString* updateString = [NSString stringWithFormat:pbaseUpdateImageString,
													   MakeStringURLEncodingFriendly(title),
													   MakeStringURLEncodingFriendly(caption),
													   MakeStringURLEncodingFriendly(shotDate),
													   cameraBodyID,
													   MakeStringURLEncodingFriendly(cameraBody),
													   cameraLensID,
													   MakeStringURLEncodingFriendly(cameraLens),
													   MakeStringURLEncodingFriendly(description),
													   MakeStringURLEncodingFriendly(keywords)];
													   
	return updateString;
}


@end
