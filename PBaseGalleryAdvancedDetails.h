//
//  PBaseGalleryAdvancedDetails.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 12/29/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncWebRequest.h"

@class PBGallery;

@interface PBaseGalleryAdvancedDetails : AsyncWebRequest 
{

}

/**
	This will call the PBaser server to update the gallery's advanced detials.
	
	\param  galleryToUpdate the gallery to update
	\param  user the PBase user name
	\return none
	\sa
**/
- (void)setGalleryAdvancedDetails:(PBGallery*)galleryToUpdate forUser:(NSString*)userName;

/**
	This call parses the data that was recieved from the web call.
	
	\param  data the data to parse.
	\return A  NSError pointer to a valid error if there was an error. nil if
	there was no error
	\sa
**/
- (NSError*)parseRecievedData:(NSData*)data;

@end
