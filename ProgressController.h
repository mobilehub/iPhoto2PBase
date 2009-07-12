/* ProgressController */

#import <Cocoa/Cocoa.h>
#import "PBUploader.h"

@class PBUploader; 
     
@interface UploadProgressController : NSWindowController
{
    IBOutlet NSProgressIndicator *progressBar;
    IBOutlet NSTextField *progressText;
	
	bool cancelled;
	
	PBUploader* uploader;
}

-(id)initController;
-(void)setUploader:(PBUploader*)aUploader;
-(IBAction)onCancel:(id)sender;
-(void)progressClose;

-(void)uploaderBeginImage:(NSString*)fileName;
-(void)uploaderEndImage;
-(void)uploaderSetNumberFiles:(NSNumber*)fileCount;
-(void)uploaderCompleted;
-(void)uploaderCancelled;

@end
