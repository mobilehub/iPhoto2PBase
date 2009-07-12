//
//  PBaseGalleryCreator.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 7/4/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AsyncWebRequest.h>

@class PBGallery;

@interface PBaseGalleryCreator : AsyncWebRequest
{
	PBGallery* galleryToBeCreated;
}

-(id)initWithDelegate:(id)aDelegate;
-(void) createGallery:(PBGallery*)galleryToCreate forUser:(NSString*)user;
-(NSError*) parseRecievedData:(NSData*)data;

@end