//
//  PBImageToUpload.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 3/29/05.
//  Copyright 2005 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ExportMgr; 

@interface PBImageToUpload : NSImage 
{
	NSString* descriptionText;
	NSString* title;
	NSSize originalSize;
	NSSize newSize;
	NSString* originalFileName;
	NSString* convertedFileName;
	NSString* keywords;
	
	ExportMgr* exportMgr;
	
	NSString* imageFormat;
	NSString* uploadName;
	int nPhotoType;
	bool landscape;
	float aspectRatio;
}

-(id) initWithExportMgr:(ExportMgr*)mgr index:(int)index;

-(void) dealloc;

-(NSString*) descriptionText;
-(void) setDescriptionText:(NSString*)newDescription;

-(NSString*) title;
-(void) setTitle:(NSString*)newTitle;

-(int)newSizeWidth;
-(void)setNewSizeWidth:(int)width;

-(int)newSizeHeight;
-(void)setNewSizeHeight:(int)height;

-(NSString*)originalFileName;
-(void)setOriginalFileName:(NSString*)fileName;

-(NSString*)keywords;
-(void)setKeywords:(NSString*)someKeywords;

-(void)setNewSizeWidthAdjustHeight:(int)width;
-(void)setNewSizeHeightAdjustWidth:(int)height;

-(NSString*)uploadName;
-(NSString*)getDescriptionFromIPhoto:(ExportMgr*)mgr index:(int)index;

-(bool) isResized;
-(NSString*)uploadName;
-(bool)doConversion;
-(bool)isJPEG;

-(bool)isLandscape;
-(void)cleanup;
@end
