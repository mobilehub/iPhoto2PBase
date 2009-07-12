//
//  CreateGalleryPanelController.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 6/26/05.
//  Copyright 2005 New Wave Digital Media. All rights reserved.
//

#import "CreateGalleryPanelController.h"
#import "PBGallery.h"
#import "PBaseGalleryCreator.h"
#import "PBaseGalleryDetails.h"
#import "PBaseServerGalleryRetriever.h"
#import "PBaseGalleryAdvancedDetails.h"
#import "WebMenChoice.h"
#import "utils.h"
#import "PBaseExporter.h"

@implementation CreateGalleryPanelController

-(void) awakeFromNib
{
	[[countryMenu menu] insertItem: [NSMenuItem separatorItem] atIndex:1];
	
	[[styleMenu menu] insertItem: [NSMenuItem separatorItem] atIndex:1];
	
	if (customStyleSeperator != NSNotFound)
		[[styleMenu menu] insertItem: [NSMenuItem separatorItem] atIndex:customStyleSeperator-1];
    
	// our login controls are what we want to see first.
	[self setContentView:createGalleryView];
	
	

}

-(id) initWithExporter : (PBaseExporter*)anExporter
{
	if (self = [super initWithWindowNibName:@"Create Gallery"])
	{
		theGalleries = [[anExporter galleries] retain];
		theCountries = [[anExporter countryMenu] retain];
		
		// setup the who can post options.
        whoCanPostOptions = CreateWebMenuArrayFromStringFile(@"WhoCanComment", 4);
        
		// setup the alignment options.
		alignments = CreateWebMenuArrayFromStringFile(@"Alignment", 3);
		
		parentWindow = [[anExporter parentWindow] retain];
		theGalleryStyles = [[anExporter galleryStyleMenu] retain];
		
		user = [[anExporter pbaseUser] retain];
		newGalleryIndex = 0;
		galleryCreator = nil;
		galleryRetriever =  nil;
		galleryUpdater = nil;
		newGallery = nil;
		
		currentRequest = nil;
		
		testGallery = [[PBGallery alloc] init];
		
		[testGallery setParentGallery:[theGalleries objectAtIndex:0]];
        
        // set our stylesheet to the first style sheet.. 
        [testGallery setStyleSheet:[theGalleryStyles objectAtIndex:0]];
		
        // set the default country..
        [testGallery setCountry: [theCountries objectAtIndex:0]];
		
		// set the default alignment...
		[testGallery setAlignment: [alignments objectAtIndex:0]];
		
		// set the who can comment options.
		[testGallery setWhoCanComment:[whoCanPostOptions objectAtIndex:0]];
		
    
		customStyleSeperator = [anExporter customStyleSeperator];
	}
	
	return self;
}


-(void) setContentView:(NSView*)view
{
	NSRect rect = [view bounds];
	NSRect frameRect = [[self window] frameRectForContentRect:rect];
	NSRect frame = [[self window] frame];
	NSRect parentRect = [parentWindow frame];
	NSWindow* window_ = [self window];
	NSPoint tOrigin;
	//int newHeight = rect.size.height;
	NSRect tWindowFrame=[window_ frame];
	NSRect nWindowFrame;

	tOrigin.x=0;
	tOrigin.y=0;
	
	
	nWindowFrame=[NSWindow frameRectForContentRect:NSMakeRect(0,0,rect.size.width,rect.size.height) styleMask:[window_ styleMask]];
	
	NSRect panelRect = NSMakeRect(tWindowFrame.origin.x-((nWindowFrame.size.width-
		tWindowFrame.size.width)/2),tWindowFrame.origin.y-(nWindowFrame.size.height-
		tWindowFrame.size.height),nWindowFrame.size.width,nWindowFrame.size.height);
		
	
	[window_ 
		setFrame: panelRect
		display:YES animate:YES];
		
  
	[[self window] setContentView:view];
}

-(IBAction) doCreateGallery:(id) sender
{
	
	[creatingGallery commitEditing];
	
    
	PBGallery* gallery = [creatingGallery content];
		
	if (gallery != nil)
	{
		galleryCreator = [[PBaseGalleryCreator alloc] initWithDelegate:self];
		
		currentRequest = galleryCreator;	
				
		if (galleryCreator != nil)
		{
			[progressView setHidden:NO];
			
			[self setContentView:progressView];

			[[self window] display];

			[progress setUsesThreadedAnimation:YES];
			[progress startAnimation:self];
			[statusText setStringValue:PluginGetLocalizedString(@"creating_gallery")];
			
			[self setGalleryToCreate:gallery];
		
			[galleryCreator createGallery:gallery forUser:user];
		}
	}
}

-(IBAction) doCancelledCreate:(id)sender
{
	[currentRequest cancel];	
	
	[self closePanel];
}

-(void)setGalleryToCreate:(PBGallery*)aGallery
{
	[galleryToCreate autorelease];
	
	galleryToCreate = [aGallery retain];
}

-(PBGallery*)galleryToCreate
{
	return galleryToCreate;
}

-(PBGallery*) findGalleryWithTitle:(NSString*) name index:(int*)index
{
	int nGallery = 0;
	
	for (nGallery = 0; nGallery < [theGalleries count]; nGallery++)
	{
		PBGallery* foundGallery = nil;

		foundGallery = [theGalleries objectAtIndex:nGallery];
		
		if ([name isEqualTo:[foundGallery name]])
		{	
			*index = nGallery;
			return foundGallery;
		}
	}
	
	return nil;
	
}

-(IBAction) doCancel:(id)sender
{
	canceled = YES;
	
	[self closePanel];
	
}

-(bool) isChildGallery;
{
	return [isChildGallery state] == NSOnState;
}

-(void)closePanel
{
	[progress stopAnimation:self];
//	[[self window] setContentView:loginView]; 
	[self close];
	[NSApp endSheet:[self window] returnCode:0];
//	[self resetControlState];
}

-(bool)canceled 
{
	return canceled;
}


-(NSMutableArray*)galleries
{
	return theGalleries;
}

-(void)setGalleries:(NSMutableArray*)galleries
{
	[theGalleries release];
	
	theGalleries = [galleries retain];
}

-(int)newGalleryIndex
{
	return newGalleryIndex;
}

-(void)dealloc
{
	[theGalleries release];
	[theCountries release];
	[theGalleryStyles release];

	[super dealloc];
}


#pragma mark ----------- Async Web Request Handlers -------------

-(void) webRequestDidFinishLoading:(AsyncWebRequest*)webRequest
{
	if (webRequest == galleryCreator)
	{
					// refresh our gallery list... 
		galleryRetriever = [[PBaseServerGalleryRetriever alloc] initWithDelegate:self];

		currentRequest = galleryRetriever;			
		
		[galleryRetriever retrieveGalleries];
		
		galleryCreator = nil;
	}
	else if (webRequest == galleryUpdater)
	{
		newGallery = nil;

		galleryUpdater = nil;
		
		 // setup our advanced settings POST. 
		galleryAdvancedDetails = [[PBaseGalleryAdvancedDetails alloc] initWithDelegate:self];
		
		[galleryAdvancedDetails setGalleryAdvancedDetails:galleryToCreate forUser:user];
	}
	else if (webRequest == galleryRetriever)
	{
		[self setGalleries:[galleryRetriever galleries]];
		        
		newGallery = [self findGalleryWithTitle: [galleryToCreate name] index:&newGalleryIndex];
				   
		[galleryToCreate setNumber:[newGallery number]];
        
		galleryUpdater = [[PBaseGalleryDetails alloc] initWithDelegate:self];

		currentRequest = galleryUpdater;			
		
		[statusText setStringValue:PluginGetLocalizedString(@"updating_details")];

		[galleryUpdater setGalleryDetails:galleryToCreate forUser:user];

		galleryRetriever = nil;
	}
	else if (webRequest == galleryAdvancedDetails)
	{
		galleryToCreate = nil;
		galleryAdvancedDetails = nil;
		
		[self closePanel];
	}
	

	[webRequest release];
}

-(void) webRequestDidFailWithError:(AsyncWebRequest*)webRequest
{
	NSError* error = [webRequest error];
	
	NSAlert* alert = [NSAlert alertWithMessageText:PluginGetLocalizedString(@"unable_to_create_gallery")
							  defaultButton:@"OK"
							  alternateButton:nil
							  otherButton:nil
							  informativeTextWithFormat: [error localizedDescription]];
							  
	
	NSString* iconPath = PluginGetLocalizedPathForImage(@"iPhoto2Pbase");
	
	NSImage* icon = [[NSImage alloc] initByReferencingFile:iconPath];
	
	[alert setIcon:icon];

	[icon release];
	
	[webRequest release];
			
	[self closePanel];
}

@end
