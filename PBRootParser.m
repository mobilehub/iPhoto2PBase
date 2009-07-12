//
//  PBRootParser.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 8/3/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import "PBRootParser.h"
#import "WebMenChoice.h"
#import "NSError_Extension.h"
#import "PBaseConstants.h"
#import "utils.h"

@implementation PBRootParser


-(void)parseRootGallery:(NSString*)userName
{
	galleryStyles = nil;
	
	// first get our defualt galleries
	[self fillStyleArrayWithDefaultStyles];
	
	//http://upload.pbase.com/edit_gallery/
	// let's build our request... 
	NSString* urlString = [[[NSString alloc]initWithFormat:@"%@%@/root", pbaseUpload, userName] autorelease];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
	customStyleSeperatorLocation = NSNotFound;
		
	[self sendRequest:request];	
}

-(void)fillStyleArrayWithDefaultStyles
{		
	galleryStyles = [CreateWebMenuArrayFromStringFile(@"GalleryStyles", 12) retain];	
}

-(NSArray*) getStyleMenuItems
{
	return galleryStyles;
}

-(void) dealloc
{
	[galleryStyles release];
	[super dealloc];
}

-(NSError*) parseRecievedData:(NSData*)data
{
	// we need to parse the result. see what we got back.. 
	NSError* error = nil;
	NSError* xmlError = nil;
	NSArray* foundNodes;
	int err = SERVER_SUCCESS;
	NSXMLDocument* doc = [[[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyHTML error:&xmlError] autorelease];
	//NSLog ([doc XMLString]);
	
	if (doc != nil)
	{
		NSArray* foundNodes = [doc nodesForXPath:@"//select[@name=\"css_id\"]//option" error:&xmlError];
		
		NSEnumerator* enumerator = [foundNodes objectEnumerator];
		NSXMLNode* node;
			
		err = SERVER_SUCCESS;
        bool bFirst = true;
		
		// lets create a gallery out of each node.
		while (node = [enumerator nextObject])
		{
			NSXMLNode* valueNode = [[node nodesForXPath:@"@value" error:&xmlError] objectAtIndex:0];
			WebMenuChoice* menuChoice = nil;
			
			// get name and value strings
			NSString* name = [node stringValue];
			NSString* value = [valueNode stringValue];
			
			// if its not seperator we go ahead and add the style.
			if (![value isEqualToString:@"-"] && ![value isEqualToString:@"t1"] && ![value isEqualToString:@"--"])
			{
				menuChoice = [[[WebMenuChoice alloc] initWithName:name command:value] autorelease];
					
				if (galleryStyles != nil && menuChoice != nil)
				{
					
					if ([galleryStyles indexOfObject:menuChoice] == NSNotFound)
					{
						// if this is the first custom item then we need
						// to record the location of the seperator that seperates 
						// built in styles with custom styles.
						if (bFirst)
						{
							customStyleSeperatorLocation = [galleryStyles count] + 1;
							
							// make sure we set the first flag to false.
							bFirst = false;
						}
						
						// add the new menu item.
						[galleryStyles addObject:menuChoice];
					}	
				}
			}
			
			//NSLog(value);
		
		}

	}
}

-(unsigned int)customStyleSeperatorLocation
{
	return customStyleSeperatorLocation;
}
@end
