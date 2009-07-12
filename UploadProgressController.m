#import "UploadProgressController.h"
#import "PBUploader.h"
#import "utils.h"
#import "ImageOnlineData.h"
#import "PBImageToUpload.h"
#import "ImageUpdater.h"

@implementation UploadProgressController

-(void)awakeFromNib
{
	[progressBar setMaxValue:(double)[filesToUpload count]];
	[self uploadNextFile];
	//[self performSelector:@selector(uploadNextFile) withObject:nil afterDelay:1.0];
}

-(id)initControllerWithFiles:(NSArray*)files forGallery:(PBGallery*)gallery forUser:(NSString*)user;
{
	if (self = [super initWithWindowNibName:@"Progress"])
	{
		cancelled = false;
	
		currentFile = nil;
		fSteps = 0.0;
	
		// stash our files to upload
		filesToUpload = [files retain];
	
		// get the enumerator. we will use this to 
		// walk trhough our array.
		enumerator = [[filesToUpload objectEnumerator] retain];
		
		parentGallery = [gallery retain];
		userName = [user retain];
	}
	
	return self;
}

-(void) dealloc
{
	[enumerator release];
	[filesToUpload release];
	
//	if (currentRequest != nil)
//		[currentRequest release];
	
	[currentFile release];
	[userName release];
	[parentGallery release];
	
	[super dealloc];
}

-(bool)uploadNextFile
{
	// default to false. Will be set to true if there is 
	bool result = false;
	
	// set the current file.
	[currentFile release];
	currentFile = [[enumerator nextObject] retain];
	
	// if we have a file.. 
	if (currentFile != nil)
	{
		result = true;
		
		// lets create a new connection..
		currentRequest = [[PBUploader alloc] initWithDelegate:self];
		
		[currentRequest doUpload:currentFile  toGallery:parentGallery forUser:userName];
		
	}		
	
	
	return result;
}


- (IBAction)onCancel:(id)sender
{
	if (currentRequest != nil)
	{
		[currentRequest cancel];
		[self progressClose];
	}
}

-(void)updateFileConversionProgress:(NSNumber*)status
{
	NSString* fileName  = [currentFile title];
	
	switch ([status longValue])
	{
		case upload_ImageBegin:
			[progressText setStringValue: [NSString stringWithFormat:PluginGetLocalizedString(@"uploading"), fileName]];
			[progressBar incrementBy:0.5];
			fSteps += 0.5;
		
			break;
			
		case upload_ImageStartConversion:			
			[progressText setStringValue: [NSString stringWithFormat:PluginGetLocalizedString(@"converting"), fileName]];
			[progressBar incrementBy:0.5];
			fSteps += 0.5;
		
			break;
			
		case upload_ImageResizeImage:
			[progressText setStringValue: [NSString stringWithFormat:PluginGetLocalizedString(@"resizing"), fileName]];
			[progressBar incrementBy:0.5];
			fSteps += 0.5;
			
		case upload_Finish:
			[progressBar incrementBy:(1.0-fSteps)];
			fSteps = 0;

			break;
	}
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

-(void) webRequestDidFinishLoading: (AsyncWebRequest*)webRequest
{
	if (webRequest == currentRequest)
	{
		imageData = [[ImageOnlineData alloc] initWithDelegate:self];
		
		[imageUpdateURL release];
		
		imageUpdateURL = [[currentRequest URL] retain];
		
		[imageData readImageData:imageUpdateURL];
		
		//[currentRequest release];
	}
	else if (webRequest == imageData)
	{
		NSString* keywords = [currentFile keywords];
		
		if ([keywords length] > 0)
		{
			NSString* command = [imageData updateStringWithKeywords:keywords];
			
			imageUpdater = [[ImageUpdater alloc] initWithDelegate:self];
			
			[imageUpdater updateImage:imageUpdateURL withCommand:command];
			
		//	[imageData release];
		}
		else
		{
			[self updateFileConversionProgress:[NSNumber numberWithInt:upload_Finish]];
			
			if (![self uploadNextFile])
				[self progressClose];
		}
	}
	else if (webRequest == imageUpdater)
	{
		//[imageUpdater release];
			[self updateFileConversionProgress:[NSNumber numberWithInt:upload_Finish]];
			
			if (![self uploadNextFile])
				[self progressClose];

	}
	
	[webRequest release];
}

-(void) webRequestDidFailWithError: (AsyncWebRequest*)webRequest
{		
	NSError* error = [webRequest error];
	
	NSAlert* alert = [NSAlert alertWithMessageText:PluginGetLocalizedString(@"unable_to_upload_image")
							  defaultButton:@"OK"
							  alternateButton:nil
							  otherButton:nil
							  informativeTextWithFormat: [error localizedDescription]];
							  
	
	NSString* iconPath = PluginGetLocalizedPathForImage(@"iPhoto2Pbase");
	
	NSImage* icon = [[NSImage alloc] initByReferencingFile:iconPath];
	
	[alert setIcon:icon];

	[icon release];
	
	[webRequest release];

	[self progressClose];
}

@end
