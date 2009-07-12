//
//  QuotaRetriever.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 3/20/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncWebRequest.h"

@interface QuotaRetriever : AsyncWebRequest 
{
	NSString* mbUsed;
	NSString* monthsRemaining;

	NSString* galleryCount;
	NSString* imagesOnline;

}

-(void) retrieveQuota;
-(NSError*) parseRecievedData:(NSData*)data;

-(NSString*) mbUsed;
-(NSString*) monthsReamining;
-(NSString*) galleryCount;
-(NSString*) imagesOnline;

@end
