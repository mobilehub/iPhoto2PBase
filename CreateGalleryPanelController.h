//
//  CreateGalleryPanelController.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 6/26/05.
//  Copyright 2005 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PBaseGalleryCreator;
@class PBaseGalleryDetails;
@class PBaseServerGalleryRetriever;
@class PBGallery;
@class AsyncWebRequest;
@class PBaseExporter;
@class PBaseGalleryAdvancedDetails;

@interface CreateGalleryPanelController : NSWindowController 
{
	IBOutlet NSArrayController* galleryController;
	IBOutlet NSArrayController* countryMenuArray;
	IBOutlet NSArrayController* galleryStyleContoller;
    IBOutlet NSArrayController* whoCanPostController;
    IBOutlet NSArrayController* alignmentController;
	
    
    //IBOutlet NSTextView* galleryDescription;
	IBOutlet NSTextField* galleryName;
	IBOutlet NSButton* isChildGallery;
	IBOutlet NSProgressIndicator* progress;	
	
	IBOutlet NSView* progressView;
	IBOutlet NSView* createGalleryView;
	IBOutlet NSPopUpButton* countryMenu;
	IBOutlet NSPopUpButton* styleMenu;
	IBOutlet NSTextField* statusText;
	
	PBaseGalleryCreator* galleryCreator;
	PBaseGalleryDetails*  galleryUpdater;
	PBaseServerGalleryRetriever* galleryRetriever;
	PBaseGalleryAdvancedDetails* galleryAdvancedDetails;
	
	NSString* user;
	NSMutableArray* theGalleries;
	
	PBGallery* newGallery;
	PBGallery* galleryToCreate;
	PBGallery* testGallery;
	
	NSArray* theCountries;
	NSArray* theGalleryStyles;
    NSArray* whoCanPostOptions;
	NSArray* alignments;
    
	AsyncWebRequest* currentRequest;
	
	NSWindow* parentWindow;
	bool canceled;
	int newGalleryIndex;
	
	int customStyleSeperator;
	
	IBOutlet NSObjectController* creatingGallery;
}

-(id) initWithExporter : (PBaseExporter*)anExporter;

-(void) setContentView:(NSView*)view;

-(IBAction) doCreateGallery:(id) sender;
-(IBAction) doCancel:(id)sender;
-(IBAction) doCancelledCreate:(id)sender;

-(PBGallery*) findGalleryWithTitle:(NSString*) name index:(int*)index;
-(bool) isChildGallery;

-(void)closePanel;
-(bool)canceled;

-(NSMutableArray*)galleries;
-(void)setGalleries:(NSMutableArray*)galleries;

-(int)newGalleryIndex;

-(void)setGalleryToCreate:(PBGallery*)aGallery;
-(PBGallery*)galleryToCreate;

@end
