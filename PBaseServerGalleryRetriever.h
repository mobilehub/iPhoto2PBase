//
//  PBaseServerGalleryRetriever.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 6/27/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncWebRequest.h"

@interface PBaseServerGalleryRetriever : AsyncWebRequest 
{
	NSMutableArray* galleries;
}

-(void)retrieveGalleries;
-(NSError*)parseRecievedData:(NSData*)data;
-(NSMutableArray*)galleries;

@end
