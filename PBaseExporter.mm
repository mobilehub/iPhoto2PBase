#import "PBaseExporter.h"
#import "PBLoginPanelController.h"
#import "PBGallery.h"
#import "PBImageToUpload.h"
#import "UploadProgressController.h"
#import "CreateGalleryPanelController.h"
#import "utils.h"
#import "WebMenChoice.h"
#import "QuotaRetriever.h"
#import "MUPhotoView_NewWaveDigitalMedia.h"

@implementation PBaseExporter

static int compareCountryMenuItems(id p1, id p2, void *context);

-(void)awakeFromNib
{
	// set up the photoview options
	[photoView setRowAndColumnHeading:MUStaticRowCount];
	[photoView setRowCount: 1];
	[photoView setCanDrag: NO];
	[photoView setUseBorderSelection:YES];
	[[photoView enclosingScrollView] setBorderType:NSGrooveBorder];
	
	[photoView bind:@"photosArray" toObject:imagesToExportController withKeyPath:@"arrangedObjects" options:nil];
    [photoView bind:@"selectedPhotoIndexes" toObject:imagesToExportController withKeyPath:@"selectionIndexes" options:nil];	
}

- (void)writePrefs
{
    NSString *identifier = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if (userDefaults != nil)
	{
		[defaults setPersistentDomain: userDefaults forName: identifier];
		[defaults synchronize];
	}
}

- (id)initWithExportImageObj:(id <ExportImageProtocol>)exportMgr
{
	if (self = [super init])
	{
	    uploader = nil;
		
		loginController = nil;
		//createGalleryController = nil;
		progressController = nil;
		
		exportManager = (ExportMgr*)exportMgr;
		int f = [NSBundle loadNibNamed:@"IPhoto2PBase" owner:self];
				
			
		//NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		userDefaults = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:[[NSBundle bundleForClass:[self class]] bundleIdentifier]] mutableCopy];
		
		if (userDefaults == nil)
			userDefaults = [[NSMutableDictionary alloc] init];
			
		galleries = nil;
				
		NSMutableArray *newGalleries = [[NSMutableArray alloc] init];
		PBGallery* galleryData = [[PBGallery alloc]init];

		[newGalleries addObject:galleryData];
		[galleryData release];
	
		[self setGalleries:newGalleries];
		
		[galleryList setEnabled:NO];
		
		bActivated = false;
		
		customStyleSeperator = NSNotFound;
		

	}
	
	return self;
}

- (id)settingsView
{
	return settingsView;
}

- (id)firstView
{
	return firstView;
}

- (id)lastView
{
	return lastView;
}


 
- (BOOL)handlesMovieFiles 
{ 
 return NO; 
} 
 

- (void)viewWillBeActivated
{
	[self fillCountryArray];

		// get the count of how many images we have.
	unsigned int nCount = [exportManager imageCount];
	unsigned int nImage = 0;
		
	// lets just try this.. 
	NSMutableArray* images = [[NSMutableArray alloc] init];
	
	for (nImage = 0; nImage < nCount; nImage++)
	{
		PBImageToUpload* imageToUpload = [[PBImageToUpload alloc] initWithExportMgr:exportManager index:nImage];
		
		[images addObject:imageToUpload];
		
		[imageToUpload release];
	}
	
	[self setImagesToExport:images];
	[images release];
}

- (void)viewWillBeDeactivated
{
	[self writePrefs];
}

- (id)requiredFileType
{
	return nil;
}

- (BOOL)wantsDestinationPrompt
{
	return NO;
}

- (id)getDestinationPath
{
	return [NSString stringWithFormat:@"%@/img.jpg", NSHomeDirectory()];
}

- (id)defaultFileName
{
	return @"image.jpg";
}

- (id)defaultDirectory
{
	return NSHomeDirectory();
}

- (BOOL)treatSingleSelectionDifferently
{
	return NO;
}

- (BOOL)validateUserCreatedPath:(id)fp12;
{
	return YES;
}

- (void)clickExport
{
}

- (void)startExport:(id)fp12;
{
	if (bLoggedIn)
	{
		NSString* loginName = [user stringValue];
		
		[imagesToExportController commitEditing];
		
		int nIndex = [galleryController selectionIndex];

		// get the selected gallery.
		PBGallery* gallery = [galleries objectAtIndex:nIndex];
		
		progressController = [[UploadProgressController alloc] initControllerWithFiles:imagesToExport forGallery:gallery forUser:loginName];
				
		[NSApp beginSheet:[progressController window]
		   modalForWindow:[[self settingsView] window]
			modalDelegate:self
		   didEndSelector: @selector(uploadProgressEnded:returnCode:context:)
			  contextInfo:NULL];		
	}
}

- (void)performExport:(id)fp12;
{
}

- (void *)progress
{
	return (void*)@"";
}

- (void)lockProgress
{
}

- (void)unlockProgress
{
}

- (void)cancelExport
{
	[self reset];
	bActivated = false;
}

-(void)cancelExportBeforeBeginning
{
}

- (id)name
{
	return @"";
}

- (id)description
{
	return @"Upload you photos to pbase";
}

-(IBAction)login:(id)sender
{
	if (loginController == nil)
	{	
		loginController = [[PBLoginPanelController alloc] initWithPrefs:userDefaults];
	}
	
	
	
	[NSApp beginSheet:[loginController window]
	 modalForWindow:[exportManager window]
	 modalDelegate:self
	 didEndSelector: @selector(loginSheetEnded:returnCode:context:)
     contextInfo:NULL];
	
}


-(void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	[sheet orderOut:self];

	if (returnCode == NSAlertAlternateReturn)
	{
		[loginController release];
		loginController = nil;
		
		[self writePrefs];
	}
	else
	{
		[self login:self];
	}
	
}

- (void)loginSheetEnded:(NSWindow*)sheet returnCode:(int)returnCode context:(void*)contextInfo
{
	// if we are logged in then we need to go ahead and
	// set the suser name and get the gallery array...
	if (returnCode == 1)
	{
		NSString* pData = [loginController loginName];
		[user setStringValue:pData];
		
		[self writePrefs];
		
		customStyleSeperator = [loginController customStyleSeperator];
		
		[self setGalleries: [loginController galleries]];
		
		QuotaRetriever* qr = [loginController quotas];
		
		[mbUsed setStringValue:[qr mbUsed]];
		[galleryCount setStringValue:[qr galleryCount]];
		[numImages setStringValue:[qr imagesOnline]];
		[monthsLeft setStringValue:[qr monthsReamining]];
		
		bLoggedIn = YES;
		
        galleryStyles = [[loginController styleMenu] retain];
	}
	
	[galleryList setEnabled:bLoggedIn];
	[createGalleryButton setEnabled:bLoggedIn];
	[createGalleryLabel setEnabled:bLoggedIn];
	[loginController release];
	loginController = nil;
	
}

-(NSMutableArray*) imagesToExport
{
	return imagesToExport;
}

-(void)setImagesToExport:(NSMutableArray*)newImagesToExport
{
	if (newImagesToExport != imagesToExport)
	{
		[imagesToExport release];
		
		imagesToExport = [newImagesToExport retain];
	}
}

-(void) setGalleries:(NSMutableArray*)newGalleries
{
	if (newGalleries != galleries)
	{
		[galleries release];
		
		[newGalleries retain];
	
		galleries = newGalleries;
		
		[galleryController setSelectionIndex:1];
	}
}

-(NSMutableArray*)galleries
{
	return galleries;
}

-(void)uploadProgressEnded:(NSWindow*)sheet returnCode:(int)returnCode context:(void*)contextInfo
{
	[sheet orderOut:self];
	
	if (returnCode == 1)
	{
		[[exportManager exportController] cancel: self];	
		bActivated = false;
	}
	
	[progressController release];
	progressController = nil;

}

- (IBAction) createGallery:(id)sender
{
	CreateGalleryPanelController* createGalleryController = [[CreateGalleryPanelController alloc] initWithExporter: self];	
	
	[NSApp beginSheet:[createGalleryController window]
	   modalForWindow:[[self settingsView] window]
		modalDelegate:self
	   didEndSelector: @selector(createGallerySheetEnded:returnCode:context:)
		  contextInfo:createGalleryController];		
	
}

- (void)createGallerySheetEnded:(NSWindow*)sheet returnCode:(int)returnCode context:(void*)contextInfo
{
	CreateGalleryPanelController* createGalleryController = (CreateGalleryPanelController*)contextInfo;
	
	if (![createGalleryController canceled])
	{
		[self setGalleries:[createGalleryController galleries]];
		
		[galleryController setSelectionIndex:[createGalleryController newGalleryIndex]];
				
	}
	
	[galleryList setEnabled:YES];

	
	[createGalleryController release];
	createGalleryController = nil;
}

-(IBAction)about:(id)sender
{
					  
	[self doAbout];
}

-(void)doAbout
{
	[NSApp beginSheet: aboutPanel
	   modalForWindow: [[self settingsView] window]
		modalDelegate: self
	   didEndSelector: @selector(aboutSheetDidEnd:returnCode:context:)
		  contextInfo:NULL];
}
-(IBAction)aboutOK:(id)sender
{
	[aboutPanel orderOut:sender];
	[NSApp endSheet:aboutPanel returnCode:ABOUT_OK];

}

-(IBAction)aboutWeb:(id)sender
{	
	[[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"http://www.newwavedigitalmedia.com"]];
}



- (void)aboutSheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode context:(void*)contextInfo
{
}

-(void) reset
{
	[galleries release];
	[countryArray release];
	[imagesToExport release];
	[uploader release];
	[galleryStyles release];
}

-(void)dealloc
{
	// clean up by resetting.
	[self reset];
	
	[super dealloc];
}

-(void)controlTextDidChange:(NSNotification *)notification
{
	NSArray* selectedImages = [imagesToExportController selectedObjects];
	PBImageToUpload* image = [selectedImages objectAtIndex:0];
	bool bTranspose = NO;
	bool bFirstLandscape = [image isLandscape];
	NSEnumerator *enumerator = [selectedImages objectEnumerator];
	
	while (image = [enumerator nextObject])
	{
		if ([notification object] == width)
		{
			[image setNewSizeWidthAdjustHeight: [[width stringValue] intValue]];
		}
		else if ([notification object] == height)
		{
			[image setNewSizeHeightAdjustWidth: [[height stringValue] intValue]];
		}
	}
}

-(void)fillCountryArray
{
	[countryArray release];
	
	countryArray = [[NSMutableArray arrayWithCapacity:100] retain];
	
	for (int n = 0; n <= 272; n++)
	{
		NSString* command;
		
        if (n > 0) 
			command = [NSString stringWithFormat:@"%d", n];
        else
			command = @"Unspecified";
        
		// we need to load the string
		NSString* menuName = PluginGetLocalizedStringFromTable(command, @"LanguageList");
		
		
		if (menuName != nil && (![menuName isEqualToString:command] || n == 0))
		{
			WebMenuChoice* webMenuChoice = [WebMenuChoice withName:menuName command:command];
			
			if (webMenuChoice != nil)
				[countryArray addObject: webMenuChoice];
		}
	}
	
	[countryArray sortUsingFunction:compareCountryMenuItems context:nil];
}

-(void)fillArrayWithDefaultStyles
{
	
}

static int compareCountryMenuItems(id p1, id p2, void *context)
{
	WebMenuChoice* menuItem1 = p1;
	WebMenuChoice* menuItem2 = p2;
	NSString* name1 = [menuItem1 name];
	NSString* name2 = [menuItem2 name];
	NSComparisonResult result = NSOrderedSame;

	// we need to keep the "Unspecified" menu item at top.
	// if none of hte strings are unspecified then we need
	// to just do a normal string compare.
	if ([name1 isEqualToString:@"Unspecified"])
	{
		if (![name2 isEqualToString:@"Unspecified"])
			result = NSOrderedAscending;
	}
	else if ([name2 isEqualToString:@"Unspecified"])
	{
		if (![name1 isEqualToString:@"Unspecified"])
			result = NSOrderedDescending;
	}
	else
		result = [name1 compare:name2];
		

	return result;
}

-(NSArray*)countryMenu
{
	return countryArray;
}

-(NSArray*)galleryStyleMenu
{
	return galleryStyles;
}

-(NSString*)pbaseUser
{
	return [user stringValue];
}

-(NSWindow*)parentWindow
{
	return [[self settingsView] window];
}

-(int)customStyleSeperator
{
	return customStyleSeperator;
}

- (void)photoView:(MUPhotoView_NewWaveDigitalMedia *)view didSetSelectionIndexes:(NSIndexSet *)indexes
{
}

-(NSString *)imageTitleAtIndex:(unsigned)index;
{
	if (index < [imagesToExport count])
	{
		PBImageToUpload* image = [imagesToExport objectAtIndex:index];
		
		return [image title];
	}
	
	return nil;
}

@end
