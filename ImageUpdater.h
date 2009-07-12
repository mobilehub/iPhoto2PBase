//
//  ImageUpdater.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 4/5/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AsyncWebRequest.h>

@interface ImageUpdater : AsyncWebRequest 
{
}

-(void) updateImage:(NSURL*)url withCommand:(NSString*)command;

@end
