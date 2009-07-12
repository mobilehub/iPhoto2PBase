//
//  PBaseServerGalleryRetriever.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 6/27/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import "PBaseServerGalleryRetriever.h"
#import "NSError_Extension.h"
#import "PBaseConstants.h"
#import "PBGallery.h"

@implementation PBaseServerGalleryRetriever

// downlaodGalleries
//
// This will setup the download and start a new thread to handle the download.. 
-(void)retrieveGalleries
{
	// let's build our request... 
	NSString* urlString = [NSString stringWithFormat:@"%@%@", pbaseBaseURL, pbaseViewGalleries];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
		
	[self sendRequest:request];	
}

-(void)dealloc
{
	[galleries release];
	[super dealloc];
}


-(NSError*)parseRecievedData:(NSData*)data
{
	NSError* error = nil;
	NSError* xmlError = nil;
	int err = SERVER_GALLERY_LIST_NOT_FOUND;
	NSString* stringData = [[NSString alloc]initWithData:data encoding:NSISOLatin1StringEncoding];
	 
	NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithData:[stringData dataUsingEncoding:NSUTF8StringEncoding] options:NSXMLDocumentTidyHTML error:&xmlError] autorelease];
	
	// lets temporarily spit out the XML..
	//NSLog ([xmlDoc XMLString]);
	
	if (xmlDoc != nil)
	{
		NSArray* foundGalleries = [xmlDoc nodesForXPath:@"//gallery" error:&xmlError];
		
		if ([foundGalleries count] > 0)
		{
			NSEnumerator* enumerator = [foundGalleries objectEnumerator];
			NSXMLNode* node;
			
			err = SERVER_SUCCESS;
			
			// lets create a gallery out of each node.
			while (node = [enumerator nextObject])
			{
				PBGallery* gallery = [PBGallery galleryWithXMLNode:node];
				
				if (gallery != nil)
				{
					if (galleries == nil)
						galleries = [[NSMutableArray array] retain];
						
					[galleries addObject:gallery];
				}
			}
		}
		
	}
	
	
	if (err != SERVER_SUCCESS)
		[self setError:[NSError withErrorCode:[NSBundle bundleForClass:[self class]] code:err argument:nil]];
		
	return error;
}

-(NSMutableArray*)galleries
{
	return galleries;
}

@end