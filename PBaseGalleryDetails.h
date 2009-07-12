//
//  PBaseUpdateGallery.h
//
//  Created by Scott Andrew on 2006-07-05.
//  Copyright (c) 2006 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AsyncWebRequest.h>

@class PBGallery;

/** 
	This is an AsyncWebRequest subclass that will update the details
	for a given PBase gallery.
	
	\see AsyncWebRequest
**/
@interface PBaseGalleryDetails : AsyncWebRequest
{
	
}

/**
	This will call the PBaser server to update the gallery's detials.
	
	\param  galleryToUpdate the gallery to update
	\param  user the PBase user name
	\return none
	\sa
**/
- (void)setGalleryDetails:(PBGallery*)galleryToUpdate forUser:(NSString*)userName;

/**
	This call parses the data that was recieved from the web call.
	
	\param  data the data to parse.
	\return A  NSError pointer to a valid error if there was an error. nil if
	there was no error
	\sa
**/
- (NSError*)parseRecievedData:(NSData*)data;

@end

