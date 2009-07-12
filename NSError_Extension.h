//
//  NSError_Extension.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 6/20/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum
{
	SERVER_SUCCESS = 4000,
	SERVER_INVALID_USERNAME,
	SERVER_INVALID_PASSWORD,
	SERVER_UPLOAD_FAILED,
	SERVER_COULD_NO_CREATE_GALLERY,
	SERVER_COULD_NOT_UPDATE_GALLERY,
	SERVER_GALLERY_LIST_NOT_FOUND,
	SERVER_GALLERY_ALREADY_EXISTS,
	SERVER_COULD_NOT_ADVANCE_UPDATE_GALLERY,
	SERVER_COULD_NOT_CONVERT_TO_JPEG,
	SERVER_COULD_NOT_RESIZE_IMAGE,
	SERVER_COULD_NOT_UPDATE_KEYWORDS,
	SERVER_UNKNOWN_ERROR
};

@interface NSError(ServerExtension) 

+(id) withErrorCode:(NSBundle*)bundle code:(int)err argument:(NSString*)arg;
-(id) initWithErrorCode:(NSBundle*)bundle code:(int)err argument:(NSString*)arg;

@end
