/* ProgressController */

#import <Cocoa/Cocoa.h>
#import "PBUploader.h"

@class PBUploader; 
@class ImageOnlineData;
@class ImageUpdater;

enum
{
	upload_ImageBegin,
	upload_ImageStartConversion,			
	upload_ImageResizeImage,
	upload_Finish
};

@interface UploadProgressController : NSWindowController
{
    IBOutlet NSProgressIndicator *progressBar;
    IBOutlet NSTextField *progressText;
	NSArray* filesToUpload;
	PBImageToUpload* currentFile;
	NSEnumerator* enumerator;
	
	bool cancelled;
	float fSteps;
	
	// web requests.
	PBUploader* currentRequest;
	ImageOnlineData* imageData;
	ImageUpdater* imageUpdater;
	
	PBGallery* parentGallery;
	NSString* userName;
	
	NSURL* imageUpdateURL;
	
}

-(id)initControllerWithFiles:(NSArray*)files forGallery:(PBGallery*)gallery forUser:(NSString*)user;
-(IBAction)onCancel:(id)sender;
-(void)progressClose;
-(void)updateFileConversionProgress:(NSNumber*)status;
-(bool)uploadNextFile;
@end
