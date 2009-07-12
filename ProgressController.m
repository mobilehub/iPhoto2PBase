#import "ProgressController.h"
#import "PBUploader.h"

@implementation UploadProgressController

-(id)initController
{
	if (self = [super initWithWindowNibName:@"Progress"])
		cancelled = false;
	
	return self;
}
- (IBAction)onCancel:(id)sender
{
	cancelled = YES;
	
	[uploader cancel];
}

- (void)uploaderSetNumberFiles:(NSNumber*)fileCount
{
	[progressBar setMaxValue:[fileCount doubleValue]];
}

-(void)uploaderBeginImage:(NSString*)fileName
{
	[progressText setStringValue: fileName];
	[progressBar incrementBy:0.5];
}

-(void)uploaderEndImage
{
	[progressBar incrementBy:0.5];
}

-(void)uploaderCancelled
{
	[self progressClose];
}

-(void)uploaderCompleted
{
	[self progressClose];
}

-(void)progressClose
{
	[self close];
	[NSApp endSheet:[self window] returnCode:cancelled != YES];
}

-(bool)isCancelled
{
	return cancelled;
}

-(void)setUploader:(PBUploader*)aUploader
{
	uploader = aUploader;
}
@end
