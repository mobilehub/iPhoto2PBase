/* PBaseExporter */

#import <Cocoa/Cocoa.h>
#import <ExportPluginProtocol.h>
#import "ExportMgr.h"
#import "PBBox.h"
#import "PBUploader.h"

@class PBLoginPanelController;
@class CreateGalleryPanelController;
@class UploadProgressController;
@class MUPhotoView_NewWaveDigitalMedia;

#define ABOUT_OK 0
#define ABOUT_WEB 1
#define ABOUT_REGISTRATION 2

#define REGISTRATION_OK     0
#define REGISTRATION_CANCEL 1

@interface PBaseExporter : NSObject<ExportPluginProtocol>
{
    IBOutlet NSView *firstView;
    IBOutlet NSPopUpButton *galleryList;
    IBOutlet NSView *lastView;
    IBOutlet PBBox *settingsView;
    IBOutlet NSTextField *user;
	IBOutlet NSTextField* mbUsed;
	IBOutlet NSTextField* createGalleryLabel;
	IBOutlet NSTextField* galleryCount;
	IBOutlet NSTextField* numImages;
	IBOutlet NSTextField* monthsLeft;
	IBOutlet NSButton* createGalleryButton;
	IBOutlet NSWindow* aboutPanel;
	IBOutlet NSWindow* registrationPanel;
	IBOutlet NSTextField* email;
	IBOutlet NSTextField* serial;
	IBOutlet NSTextField* userName;
	IBOutlet NSTextField* regError;
	IBOutlet NSTextField* registeredTo;
	IBOutlet NSTextField* width;
	IBOutlet NSTextField* height;
	IBOutlet MUPhotoView_NewWaveDigitalMedia* photoView;
	
	// this is for our images to export.
	IBOutlet NSArrayController* imagesToExportController;
	NSMutableArray* imagesToExport;
	 
	IBOutlet NSArrayController* galleryController;
	NSMutableArray* galleries;
	
	NSDictionary* prefs;

	//NSUserDefaults userDefau
	PBUploader* uploader;
	UploadProgressController* progressController;
	
	bool bLoggedIn;
	
	ExportMgr* exportManager;
	
	PBLoginPanelController* loginController;	
	
	NSMutableArray* countryArray;
	NSArray* galleryStyles;
	
	NSMutableDictionary* userDefaults;
	int customStyleSeperator;
	
	bool bActivated;
}

-(NSMutableArray*) galleries;
-(void)setGalleries:(NSMutableArray*)newGalleries;

-(NSMutableArray*) imagesToExport;
-(void)setImagesToExport:(NSMutableArray*)newImagesToExport;

-(IBAction)login:(id)sender;
-(IBAction)createGallery:(id)sender;
-(IBAction)about:(id)sender;

-(void)doAbout;
// about box buttons....
-(IBAction)aboutOK:(id)sender;
-(IBAction)aboutWeb:(id)sender;

- (void) loginSheetEnded:(NSWindow*)sheet returnCode:(int)returnCode context:(void*)contextInfo;

-(void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
-(void)uploadProgressEnded:(NSWindow*)sheet returnCode:(int)returnCode context:(void*)contextInfo;
-(void)createGallerySheetEnded:(NSWindow*)sheet returnCode:(int)returnCode context:(void*)contextInfo;
-(void)aboutSheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode context:(void*)contextInfo;

// we want to watch for the editing being finished on our width and height.
-(void)controlTextDidChange:(NSNotification *)notification;

-(void)fillCountryArray;

-(NSArray*)countryMenu;
-(NSArray*)galleryStyleMenu;
-(NSString*)pbaseUser;
-(NSWindow*)parentWindow;

-(int)customStyleSeperator;

-(void) reset;

- (void)writePrefs;

@end
