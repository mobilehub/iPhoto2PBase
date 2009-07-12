//
//  PBRootParser.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 8/3/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncWebRequest.h"

@interface PBRootParser : AsyncWebRequest 
{
	NSMutableArray* galleryStyles;
	unsigned int customStyleSeperatorLocation;
}

-(void)parseRootGallery:(NSString*)userName;

-(void)fillStyleArrayWithDefaultStyles;

-(NSArray*) getStyleMenuItems;
-(NSError*) parseRecievedData:(NSData*)data;

-(unsigned int)customStyleSeperatorLocation;


@end
