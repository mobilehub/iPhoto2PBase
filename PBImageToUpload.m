//
//  PBImageToUpload.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 3/29/05.
//  Copyright 2005 New Wave Digital Media. All rights reserved.
//

#import "PBImageToUpload.h"
#include "ExportMgr.h"
#include "Thumbnailer.h"

@implementation PBImageToUpload

-(id) initWithExportMgr:(ExportMgr*)mgr index:(int)index;
{
	// we have the manager.. we need to get the file name before we actually can 
	// do anything.. so go to it...
	NSString* thumbFile = [mgr thumbnailPathAtIndex:index];
	
	if (thumbFile != nil)
	{
		NSString* imageTitle = nil;
		
		self = [super initWithContentsOfFile: thumbFile];
		
		if (self != nil)
		{
			if ([mgr respondsToSelector:@selector(imageTitleAtIndex:)])
				imageTitle = [mgr imageTitleAtIndex:index];
			else
				imageTitle = [mgr imageCaptionAtIndex:index];
				
			imageFormat = [[mgr getExtensionForImageFormat: [mgr imageFormatAtIndex: index]] retain];
			
			[self setDescriptionText:[self getDescriptionFromIPhoto:mgr index:index]];
		
			exportMgr = [mgr retain];
		
			if (imageTitle != nil)
				[self setTitle:imageTitle];
			else
				[self setTitle:[NSString stringWithFormat:@"Picture %d", index]];
				
			originalFileName = [[mgr imagePathAtIndex:index] retain];
			uploadName = [originalFileName retain];

			// get the photoheight..
			originalSize = [mgr imageSizeAtIndex:index];
			newSize = originalSize;
			
			// get teh aspect ratio.. 
			aspectRatio = [mgr imageAspectRatioAtIndex:index];
					
			// check to see if we are landscape or portrait.
			landscape = ![mgr imageIsPortraitAtIndex:index];
			
			keywords = nil; 
		}
	}
	
	// return ourselves.
	return self;
}

-(NSString*) descriptionText
{
	return descriptionText;
}

-(void) setDescriptionText:(NSString*)newDescription
{
	[descriptionText release];
	
	descriptionText = [newDescription retain];
}

-(NSString*) title
{
	return title;
}

-(void) setTitle:(NSString*)newTitle
{
	[title release];
	
	title = [newTitle retain];
}

-(int)newSizeWidth
{
	return (int)newSize.width;
}

-(void)setNewSizeWidth:(int)width
{
	newSize.width = (float)width; 
}
-(void)setNewSizeWidthAdjustHeight:(int)width
{
	[self setNewSizeHeight:width/aspectRatio];
	[self setNewSizeWidth:width];
}

-(int)newSizeHeight
{
	return (int)newSize.height;
}

-(void)setNewSizeHeightAdjustWidth:(int)height
{
	[self setNewSizeWidth:(height*aspectRatio)];
	[self setNewSizeHeight:height];
}

-(void)setNewSizeHeight:(int)height;
{
	newSize.height = (float)height;
}

-(NSString*)keywords
{
	return keywords;
}

-(void)setKeywords:(NSString*)someKeywords
{
	[keywords release];
	
	keywords = [someKeywords retain];
}


-(NSString*)originalFileName
{
	return originalFileName;
}

-(void)setOriginalFileName:(NSString*)fileName;
{
	[originalFileName release];
	
	originalFileName = [fileName retain];
}

-(void) dealloc
{
	[title release];
	[descriptionText release];
	[exportMgr release];
	[uploadName release];
	[originalFileName release];
	
	[super dealloc];
}

-(NSString*)getDescriptionFromIPhoto:(ExportMgr*)mgr index:(int)index
{
	NSString* imgDescription = nil;
	
	// if iphoto responds to the imageDictoinaryAtIndex then we need
	// to get the comments from the dictionary
	if ([mgr respondsToSelector: @selector(imageDictionaryAtIndex:)])
	{
		NSDictionary* metaData = [mgr imageDictionaryAtIndex:index];
		
		imgDescription = [metaData objectForKey:@"Annotation"];
	}
	else
	{
		imgDescription = [mgr imageCommentsAtIndex:index];
	}
	
	if (imgDescription == nil)
		imgDescription = @"";

	return imgDescription;
}

-(bool)isJPEG
{
	return [imageFormat isEqualToString:@"jpg"];
}

-(bool)doConversion
{
	bool succeeded = NO;
	
	// look for the extension.. 
	NSString* fileName = [[originalFileName stringByDeletingPathExtension] lastPathComponent];
	
	uploadName = [[NSString stringWithFormat:@"%@/%@.jpg", [exportMgr temporaryDirectory], fileName] retain];
	
	Thumbnailer* nailer = [exportMgr createThumbnailer];
	
	if (nailer != NULL)
	{
		NSObject* exifInfo = NULL;
		exifInfo = [nailer userDataForSrc:originalFileName];
		[nailer retrieveMetadata:originalFileName userData:&exifInfo];
		[nailer setMax:0 width:newSize.width height:newSize.height];
		[nailer setOutputExtension:@"jpg"];
		succeeded = [nailer createThumbnail:originalFileName dest:uploadName];
	}
	
	if (!succeeded)
		[uploadName release];
	
	return succeeded;
}

-(NSString*)uploadName
{
	return uploadName;
}

-(void)cleanup
{
	if (![uploadName isEqualToString:originalFileName])
	{	
		[[NSFileManager defaultManager] removeFileAtPath: uploadName handler: nil];
		[uploadName release];
		uploadName = [originalFileName retain];
		
	}

}
-(bool) isResized
{
	return (newSize.width != originalSize.width || newSize.height != originalSize.height);
}

-(bool) isLandscape
{
	return landscape;
}

@end
