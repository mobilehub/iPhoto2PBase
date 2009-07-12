//
//  PBUploader.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 4/3/05.
//  Copyright 2005 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncWebRequest.h"

@class PBImageToUpload;
@class PBGallery;

@protocol PBUploadProgress
	-(void)uploaderBeginImage:(NSString*)fileName;
	-(void)uploaderEndImage;
	-(void)uploaderSetNumberFiles:(NSNumber*)fileCount;
	-(void)uploaderCancelled;
	-(void)uploaderCompleted;
	-(void)uploaderResizeImage:(NSString*)fileName;
	-(void)uploaderStartConversion:(NSString*)fileName;
@end

@interface PBUploader : AsyncWebRequest 
{
	bool cancel;
	PBImageToUpload* imageToUpload;
	PBGallery* parentGallery;
	NSString* userName;
	NSURL* imageURL;
	
	//id<PBUploadProgress> progressDelegate;
}
-(NSURLRequest*) buildRequest;

-(void)sendRequestProxy:(NSURLRequest*)request;

-(void) doUpload:(PBImageToUpload*)image toGallery:(PBGallery*)gallery forUser:(NSString*)user;
-(NSURLRequest*) buildRequest;

-(NSError*)parseRecievedData:(NSData*)data;
-(NSURL*)URL;

@end
