//
//  QuotaRetriever.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 3/20/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import "QuotaRetriever.h"
#import "NSError_Extension.h"
#import "PBaseConstants.h"
#import "NSXMLNodeExtensions.h"
#import "Utils.h"

@implementation QuotaRetriever

-(void) dealloc
{
	[mbUsed release];
	[monthsRemaining release];

	[galleryCount release];
	[imagesOnline release];
	
	[super dealloc];
}

-(void) retrieveQuota
{
	// set up our request. its a simple get..
	NSString* urlString = [NSString stringWithFormat:@"%@%@", pbaseBaseURL, pbaseQuota];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
	[request setHTTPShouldHandleCookies:YES];

	// send the request.
	[self sendRequest:request];
}

-(NSError*) parseRecievedData:(NSData*)data
{
	NSError* xmlError = nil;

	NSString* successMsg = @"//font[text()=\"Updated advanced gallery settings\"]";
	NSArray* foundNodes = nil;
	NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyXML error:&xmlError] autorelease];
	NSString* monthsRemainingXPath = @"//td[text()=\"Months Left \"]/following::td[1]/span";
	NSString* mbUsedXPath = @"//td[text()=\"Total Storage Used \"]/following::td[1]/text()";
	NSString* galleryCountXPath = @"//td[text()=\"Galleries\"]/following::td[1]";
	NSString* imagesOnlineXPath = @"//td[text()=\"Images\"]/following::td[1]";

	// the XML is being processed by removing
	NSString* galleryCountXPathAlt = @"//td[text()=\"Galleries \"]/following::td[1]";
	NSString* imagesOnlineXPathAlt = @"//td[text()=\"Images \"]/following::td[1]";
	
	// get the MB used.
	NSString* tempString = [[xmlDoc stringFromXPath:mbUsedXPath error:&xmlError] retain];
	NSArray *lines = [tempString componentsSeparatedByString:@"\n"];
	
	mbUsed = [[lines objectAtIndex:0] retain];
	
	// we need to remove the return.. 
	
	// get the months remaining.
	monthsRemaining = [[xmlDoc stringFromXPath:monthsRemainingXPath error:&xmlError] retain];

	// get gallery counts.
	galleryCount = [[xmlDoc stringFromXPath:galleryCountXPath error:&xmlError] retain];
	
	if (galleryCount == nil)
		galleryCount = [[xmlDoc stringFromXPath:galleryCountXPathAlt error:&xmlError] retain];
		
	// images online.
	imagesOnline = [[xmlDoc stringFromXPath:imagesOnlineXPath error:&xmlError] retain];
	
	if (imagesOnline == nil)
		imagesOnline = [[xmlDoc stringFromXPath:imagesOnlineXPathAlt error:&xmlError] retain];
	
	return nil;
}

-(NSString*) mbUsed
{
	NSString* mbFormat = PluginGetLocalizedString(@"mb used");
	NSString* mbUsedString = [NSString stringWithFormat: mbFormat, mbUsed];

	return mbUsedString;
}

-(NSString*) monthsReamining;
{
	NSString* monthsRemainingFormat = PluginGetLocalizedString(@"months remaining");
	NSString* monthsRemainingString = [NSString stringWithFormat: monthsRemainingFormat, monthsRemaining];

	return monthsRemainingString;
}

-(NSString*) galleryCount
{
	NSString* galleryCountFormat = PluginGetLocalizedString(@"gallery count");
	NSString* galleryCountString = [NSString stringWithFormat: galleryCountFormat, galleryCount];

	return galleryCountString;
}

-(NSString*) imagesOnline
{
	NSString* imagesOnlineFormat = PluginGetLocalizedString(@"images online");
	NSString* imagesOnlineString = [NSString stringWithFormat: imagesOnlineFormat, imagesOnline];

	return imagesOnlineString;
}




@end
