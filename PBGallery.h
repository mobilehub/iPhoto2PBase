//
//  PBGallery.h
//  HTML Test
//
//  Created by Scott Andrew on 3/22/05.
//  Copyright 2005 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebMenuChoice;

@interface PBGallery : NSObject 
{
	NSString* name;
	NSString* number;
	NSString* title;
	NSString* description;
	NSColor* backgroundColor;
	NSColor* foregroundColor;
	NSString* columns;
	NSString* tableWidth;
	NSString* cellSpacing;
	NSString* cellPadding;
    NSString* imagesPerPage;
    NSString* oldMaxImagesPerPage;
	
	bool isChild;
	PBGallery* parentGallery;
	
	bool isPublic;
	bool enableVoting;
	bool displayExif;
	bool linkedSubgalleries;
    bool enableDirectLinking;
	bool showTitles;
	
	NSString* copyrightStatement;
	bool showImageCaptions;
	
	WebMenuChoice* styleSheet;
    WebMenuChoice* country;
    WebMenuChoice* whoCanComment;
    WebMenuChoice* alignment;
}

-(id)init;
-(id)initWithXMLNode:(NSXMLNode*)node;
-(id)initWithData:(NSString*)anID name:(NSString*)aName title:(NSString*)aTitle isPublic:(bool)isItPublic;

+(id)galleryWithXMLNode:(NSXMLNode*)node;

-(void) dealloc;

-(NSString *) name;
-(NSString*) number;
-(NSString*) title;
-(NSString*) description;
-(NSColor*) foregroundColor;
-(NSColor*) backgroundColor;

-(bool) isPublic;
-(bool) enableVoting;
-(bool) displayExif;
-(bool) linkedSubgalleries;
-(NSString*) copyrightStatement;
-(bool) showImageCaptions;

-(bool) isChild;
-(void) setIsChild:(bool)child;

// set accessors
-(void) setName:(NSString*)newName;
-(void) setNumber:(NSString*)newNumber;
-(void) setTitle:(NSString*)newTitle;
-(void) setDescription:(NSString*)newDescription;
-(void) setIsPublic:(bool)goingPublic;
-(void) setForegoundColor:(NSColor*)aColor;
-(void) setBackgroundColor:(NSColor*)aColor;
-(void) setEnalbeVoting:(bool)bEnableVoting;
-(void) setDisplayExif:(bool)bDisplayExif;
-(void) setLinkedSubgalleries:(bool)bLinked;
-(void) setCopyrightStatement:(NSString*)statement;
-(void) setShowImageCaptions:(bool)bShowImageCaptions;

-(void) setParentGallery:(PBGallery*)aGallery;
-(PBGallery*) parentGallery;

-(WebMenuChoice*) styleSheet;
-(void) setStyleSheet:(WebMenuChoice*)style;

-(WebMenuChoice*) country;
-(void) setCountry:(WebMenuChoice*)aCountry;

-(WebMenuChoice*) alignment;
-(void) setAlignment:(WebMenuChoice*)anAlignment;

-(WebMenuChoice*) whoCanComment;
-(void) setWhoCanComment:(WebMenuChoice*)who;

-(NSString*) columns;
-(void) setColumns:(NSDecimalNumber*)columnCount;

-(NSString*) tableWidth;
-(void) setTableWidth:(NSDecimalNumber*)width;

-(NSString*) cellSpacing;
-(void) setCellSpacing:(NSDecimalNumber*)spacing;

-(NSString*) cellPadding;
-(void) setCellPadding:(NSDecimalNumber*)padding;

-(NSString*) imagesPerPage;
-(void) setImagesPerPage:(NSDecimalNumber*)images;

-(bool) showTitles;
-(void) setShowTitles:(bool)show;

-(NSString*) foregroundColorAsString;
-(NSString*) backgroundColorAsString;

-(NSString*) colorAsString:(NSColor*)color;

//-(bool) setTitleAndCreateName:(NSString*)title;

-(NSString*) createValidGalleryName:(NSString*)galleryTitle;
-(NSString*) HTMLData;
-(NSString*) HTMLAdvancedData;


@end
