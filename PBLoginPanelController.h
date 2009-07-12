/* PBLoginPanelController */

#import <Cocoa/Cocoa.h>

@class PBaseServerLogin;
@class PBaseServerGalleryRetriever;
@class AsyncWebRequest;
@class PBRootParser;
@class QuotaRetriever;

@interface PBLoginPanelController : NSWindowController
{
    IBOutlet NSSecureTextField* password;
    IBOutlet NSTextField* userName;
	IBOutlet NSButton* login;
	IBOutlet NSButton* cancel;
	IBOutlet NSTextField* progressStatus;
	
	PBaseServerLogin* serverLogin;
	PBaseServerGalleryRetriever* galleryRetriever;
	QuotaRetriever* quotaRetriever;
	
	AsyncWebRequest* currentRequest;
	
	bool loggedIn;
	NSString* loginName; 
	bool canceled;

	IBOutlet NSProgressIndicator* progress;
	IBOutlet NSButton* saveInKeychain;
	bool bFoundInKeychain;
	bool bSearchKeychain;
	NSMutableDictionary* prefrences;
	IBOutlet NSView* progressView;
	IBOutlet NSView* loginView;
	NSMutableArray* galleries;
	NSArray* galleryStyles;
	int customStyleSeperator;
	
	PBRootParser* rootParser;
	
	SecKeychainItemRef keychainRef;
	
	NSRect loginRect;
	NSRect progressRect;
}

-(void)awakeFromNib;
-(id)initWithPrefs:(NSMutableDictionary*)prefs;
-(IBAction)doCancel:(id)sender;
-(IBAction)doCancleDuringLogin:(id)sender; 
-(IBAction)doLogin:(id)sender;
-(IBAction)saveInKeychainClicked:(id)sender;
-(void)closePanel;
-(NSString*)loginName;
-(bool)loggedIn;

-(NSMutableArray*) galleries;
-(QuotaRetriever*) quotas;

-(NSArray*)styleMenu;
-(int)customStyleSeperator;

-(bool) canceled;
-(void) resetControlState;

-(bool) getPasswordFromKeychain:(NSString*)user passwordData:(NSString** )pass keychainItemRef:(SecKeychainItemRef *)itemRef;
-(bool) storePasswordInKeychain:(NSString*)user password:(NSString*)pass;
-(bool) changePasswordInKeychain:(SecKeychainItemRef)itemRef user:(NSString*)user password:(NSString*)pass;

-(void) enableLoginIfNeeded;
// write to keychain
-(void)saveToKeychain;

-(void)getUIStateFromPrefs;
-(void)updatePasswordField;

-(void)savePanelPrefrences:(NSString*)lastUserName lookUpPassword:(bool)lookUpPassword;

// delegate handlers
- (void)controlTextDidEndEditing:(NSNotification *)aNotification;

-(void) setContentView:(NSView*)view withRect:(NSRect)rect;

@end
