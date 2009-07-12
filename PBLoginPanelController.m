#import "PBLoginPanelController.h"
#include <Security/Security.h>
#import "PBaseExporter.h"
#import "PBaseServerLogin.h"
#import "PBaseServerGalleryRetriever.h"
#import "utils.h"
#import "PBRootParser.h"
#import "QuotaRetriever.h"

@implementation PBLoginPanelController


-(void) awakeFromNib
{
	[self getUIStateFromPrefs];
	
	loginRect = [loginView bounds];
	progressRect = [progressView bounds];

	// our login controls are what we want to see first.
	[self setContentView:loginView withRect:loginRect]; 
	
	[self enableLoginIfNeeded];
}

- (id) initWithPrefs:(NSMutableDictionary*)prefs
{
	prefrences = [prefs retain];

	if (self = [super initWithWindowNibName:@"Login"])
	{
		bSearchKeychain = NO;
	
				
		serverLogin = nil;
		galleryRetriever = nil;
		
		customStyleSeperator = NSNotFound;
		
		galleryStyles = nil;
		loggedIn = NO;
		canceled = NO;
		
		bFoundInKeychain = NO;
		
		currentRequest = nil;
		rootParser = nil;
	
		keychainRef = 0;
		
		galleryStyles = nil;
		

	}

	return self;
	
}

-(void)getUIStateFromPrefs
{
	NSString* savedUserName = nil;
	
	if (prefrences != nil)
	{
		bSearchKeychain = [[prefrences objectForKey:@"savePassword"] boolValue];
		savedUserName = [prefrences objectForKey:@"lastLoginName"];
	}
	
	if (savedUserName != nil)
		[userName setStringValue:savedUserName];
		
	[saveInKeychain setState: bSearchKeychain ? NSOnState:NSOffState];
	
	
	if (bSearchKeychain && savedUserName != nil)
	{
		[self updatePasswordField];
	}
	
	//[NSUserDefaults resetStandardUserDefaults];
}

-(void)updatePasswordField
{
	NSString* user = [userName stringValue];
	
	if (user != nil)
	{
		NSString* foundPassword;
				
		bFoundInKeychain = [self getPasswordFromKeychain:user passwordData:&foundPassword keychainItemRef:&keychainRef];
		
		if (bFoundInKeychain)
			[password setStringValue:foundPassword];

	}
	
}

- (IBAction)doCancel:(id)sender
{
	canceled = YES;
	loggedIn = NO;
	[self closePanel];
}

- (IBAction)doCancleDuringLogin:(id)sender
{
	[currentRequest cancel];
	
	canceled = YES;
	loggedIn = NO;
	[self resetControlState];
	[self closePanel];
}

- (IBAction)doLogin:(id)sender
{ 
	NSString* user = [userName stringValue];
	NSString* pass = [password stringValue];
	NSString* statusText = PluginGetLocalizedString(@"loggin_in");
	
	[progressView setHidden:NO];
	[self setContentView:progressView withRect:progressRect];

	[progressStatus setStringValue:statusText];
	[[self window] display];
	
	[progress setUsesThreadedAnimation:YES];
	[progress startAnimation:self];
	
	serverLogin = [[PBaseServerLogin alloc]initWithDelegate:self];

	currentRequest = serverLogin;
	
	// if we allocated a server then we need to kick off the login..
	if (serverLogin != nil)
		[serverLogin login:user password:pass];	
}


-(void)saveToKeychain
{
	if (!bFoundInKeychain)
		[self storePasswordInKeychain:[userName stringValue] password:[password stringValue]];
	else if (keychainRef != 0)
		[self changePasswordInKeychain:keychainRef user:[userName stringValue] password:[password stringValue]];		
}

-(void)savePanelPrefrences:(NSString*)lastUserName lookUpPassword:(bool)lookUpPassword
{
	NSMutableDictionary* values = [NSMutableDictionary dictionary];
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary* prefs = [defaults persistentDomainForName:[[NSBundle bundleForClass:[self class]] bundleIdentifier]];

			
	[prefrences setObject:[userName stringValue] forKey:@"lastLoginName"];
	[prefrences setObject:[NSNumber numberWithBool:bSearchKeychain] forKey:@"savePassword"];
						
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:values forName:[[NSBundle bundleForClass:[self class]] bundleIdentifier]];
}

-(void)closePanel
{
	[progress stopAnimation:self];
	
	if (keychainRef != 0)
		CFRelease(keychainRef);
		
	keychainRef = 0;

	// if we logged in sucessfully then we need to go ahead and write the last
	// user name out and save the password to the key chain if needed.
	if (loggedIn)
	{
		if (bSearchKeychain)
			[self saveToKeychain];
			
		[self savePanelPrefrences:[userName stringValue] lookUpPassword:bSearchKeychain];			
	}
	
		
	[self close];
	[self resetControlState];
	[NSApp endSheet:[self window] returnCode:loggedIn];
}

-(NSMutableArray*) galleries 
{
	return galleries;
}

-(NSString*)loginName
{
	return loginName;
}

-(bool)loggedIn
{
	return loggedIn;
}

-(bool) canceled
{
	return canceled;
}

-(void) resetControlState
{
	[progress setDoubleValue:0.0];
	
	//[self setContentView:loginView withRect:loginRect]; 
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
	if ([saveInKeychain state] == NSOnState)
		[self updatePasswordField];
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
	[self enableLoginIfNeeded];
}

-(void)enableLoginIfNeeded
{
	BOOL bLoginEnabled = NO;
		
	if ([userName stringValue] != nil && [password stringValue] != nil)
	{
		if ([[userName stringValue] length] > 0 && [[password stringValue] length] > 0)
		{
			bLoginEnabled = YES;
		}
	}	
	
	
	[login setEnabled:bLoginEnabled];
}


-(bool) getPasswordFromKeychain:(NSString*)user passwordData:(NSString** )pass keychainItemRef:(SecKeychainItemRef *)itemRef;
{
	OSStatus status1 ;
	void* passwordData = NULL;
	UInt32 passwordLength = 0;
	
	if ([user length] == 0)
		return false;
 
	status1 = SecKeychainFindGenericPassword (
                 NULL,           // default keychain
                 12,             // length of account name
                 "iPhoto2PBase",   // account name
                 [user length],             // length of service name
                 [user UTF8String],   // service name
                 &passwordLength,  // length of password
                 &passwordData,   // pointer to password data
                 itemRef);         // the item reference
				 
	if (status1 == 0)
	{
		(*pass) = [[NSString alloc] initWithBytes:passwordData length:passwordLength encoding:NSUTF8StringEncoding];
	
		[(*pass) autorelease];
	
		SecKeychainItemFreeContent(NULL, passwordData);
	}
	
	 return (status1 == 0);
 }

//Call SecKeychainAddGenericPassword to add a new password to the keychain:
-(bool) storePasswordInKeychain:(NSString*)user password:(NSString*)pass;
{
	OSStatus status;
	status = SecKeychainAddGenericPassword (
                NULL,            // default keychain
                 12,             // length of account name
                 "iPhoto2PBase",   // account name
                 [user length],             // length of service name
                 [user UTF8String],   // service name
                [pass length],  // length of password
                [pass UTF8String],        // pointer to password data
                NULL);           // the item reference
    
    return (status == 0);
 }
 
-(bool) changePasswordInKeychain:(SecKeychainItemRef)itemRef user:(NSString*)user password:(NSString*)pass;
{
	OSStatus status; 
    const char *service = "iPhoto2PBase";
 
    // Set up attribute vector (each attribute consists of {tag, length, pointer}):
    SecKeychainAttribute attrs[] = {
        { kSecAccountItemAttr, [user length], (char*)[user UTF8String] },
        { kSecServiceItemAttr, strlen(service), (char *)service }   };
    const SecKeychainAttributeList attributes = { sizeof(attrs) / sizeof(attrs[0]), attrs };
 
	status = SecKeychainItemModifyAttributesAndData (
                 itemRef,        // the item reference
                 &attributes,    // no change to attributes
                 [pass length],  // length of password
                 [pass UTF8String] );        // pointer to password data
   
     return (status == 0);
 }
 
 - (IBAction)saveInKeychainClicked:(id)sender
 {
	bSearchKeychain = [saveInKeychain state] == NSOnState;
	
	if (bSearchKeychain)
		[self updatePasswordField];
 }
 
-(void)releaseLogin
{
	[serverLogin release];
}

-(void)loginCleanup
{
	[serverLogin release];
	[self performSelectorOnMainThread: @selector(resetControlState)
												  withObject: nil
											   waitUntilDone:NO];
	
}

-(NSArray*)styleMenu
{
	return galleryStyles;
}

-(int)customStyleSeperator
{
	return customStyleSeperator;
}

-(void)dealloc
{
	[loginName release]; 
	[prefrences release];
	[galleries release];
	[galleryStyles release];
	[quotaRetriever release];
	
	[super dealloc];
}

-(void) webRequestDidFinishLoading: (AsyncWebRequest*)webRequest
{
	if (webRequest == serverLogin)
	{
		NSString* statusText = PluginGetLocalizedString(@"retrieving_galleries");
		
		[progressStatus setStringValue:statusText];
		
		loginName = [[serverLogin loginName] retain];
		
		galleryRetriever = [[PBaseServerGalleryRetriever alloc] initWithDelegate:self];
	
		currentRequest = galleryRetriever; 
		
		if (galleryRetriever != nil)
			[galleryRetriever retrieveGalleries];
	}
	else if (webRequest == galleryRetriever)
	{
		galleries = [[galleryRetriever galleries] retain];
		
		loggedIn = true;
		
		rootParser = [[PBRootParser alloc] initWithDelegate:self];
		
		if (rootParser != nil)
			[rootParser parseRootGallery:loginName];
		

	}
	else if (webRequest == rootParser)
	{
		
		galleryStyles = [[rootParser getStyleMenuItems] retain];
		
		customStyleSeperator = [rootParser customStyleSeperatorLocation];
		
		quotaRetriever = [[QuotaRetriever alloc] initWithDelegate:self];
		
		if (quotaRetriever != nil)
			[quotaRetriever retrieveQuota];
			

	}
	else if (webRequest == quotaRetriever)
	{
		[quotaRetriever retain];
		
		[self performSelector:@selector(closePanel)];
	}
	
	
	[webRequest release];
}

-(void) webRequestDidFailWithError: (AsyncWebRequest*)webRequest
{
	// we are not logged in i we fail.
	loggedIn = false;
	
	[webRequest release];
	
	NSError* error = [webRequest error];
	
	NSAlert* alert = [NSAlert alertWithMessageText:PluginGetLocalizedString(@"unablelogin")
							  defaultButton:PluginGetLocalizedString(@"retry")
							  alternateButton:PluginGetLocalizedString(@"cancel")
							  otherButton:nil
							  informativeTextWithFormat: [error localizedDescription]];
							  
	
	NSString* iconPath = PluginGetLocalizedPathForImage(@"iPhoto2Pbase");
	
	NSImage* icon = [[NSImage alloc] initByReferencingFile:iconPath];
	
	[alert setIcon:icon];

	[icon release];
	
	switch([alert runModal])
	{
		case NSAlertDefaultReturn:
			[progress stopAnimation:self];
			[self setContentView:loginView withRect:loginRect]; 
			break;
		
		default:
			[self closePanel];
	}
	
}

-(QuotaRetriever*) quotas
{
	return quotaRetriever;
}


-(void) setContentView:(NSView*)view withRect:(NSRect)rect
{
//	NSRect rect = [view bounds];
	NSRect frameRect = [[self window] frameRectForContentRect:rect];
	NSRect frame = [[self window] frame];
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

@end
