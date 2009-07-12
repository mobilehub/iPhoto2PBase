//
//  ImageOnlineData.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 4/4/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncWebRequest.h"


@interface ImageOnlineData : AsyncWebRequest 
{
	NSString* caption;
	NSString* title;
	NSString* shotDate;
	NSString* cameraBodyID;
	NSString* cameraBody;
	NSString* cameraLensID;
	NSString* cameraLens;
	NSString* description;
}

-(void) readImageData:(NSURL*)url;

-(NSString*) getInputValue:(NSXMLDocument*)doc forField:(NSString*)field;
-(NSString*) getSelectedOptionID:(NSXMLDocument*)doc forField:(NSString*)field;
-(NSString*) getTextAreaText:(NSXMLDocument*)doc forField:(NSString*)field;
-(NSString*) updateStringWithKeywords:(NSString*)keywords;

@end
