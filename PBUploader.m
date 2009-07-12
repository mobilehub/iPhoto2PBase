//
//  PBUploader.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 4/3/05.
//  Copyright 2005 New Wave Digital Media. All rights reserved.
//

#import "PBUploader.h"
#import "PBImageToUpload.h"
#import "PBGallery.h"
#import "PBaseConstants.h"
#import "NSError_Extension.h"
#import "UploadProgressController.h"
#import "FileUploadStream.h"

@implementation PBUploader


-(NSURLRequest*) buildRequest
{
	NSString* urlString = [NSString stringWithFormat:@"%@%@/%@", pbaseUpload, userName, [parentGallery name]];
	NSString* contentType = [NSString stringWithFormat:pbaseUploadHeader, pbaseBoundry];
	NSString* boundryString = [NSString stringWithFormat:@"--%@\r\n", pbaseBoundry];
	NSString* endingBoundry = [NSString stringWithFormat:@"--%@--\r\n", pbaseBoundry];
	NSString* content = [NSString stringWithFormat:contentDisposition, ([imageToUpload title] == nil) ? [NSString stringWithUTF8String:" "] : [imageToUpload title]];
	NSString* seperator = [NSString stringWithFormat:@"\r\n--%@\r\n", pbaseBoundry];
	NSString* captionFormat = @"Content-Disposition: form-data; name=\"caption\"\r\n\r\n%@\r\n";
	NSString* titleFormat = @"Content-Disposition: form-data; name=\"title\"\r\n\r\n%@";
	NSString* keywordFormat = @"Content-Disposition: form-data; name=\"keywords\"\r\n\r\n%@";
	NSString* command = @"Content-Disposition: form-data; name=\"submit\"\r\n\r\nUpload Image\r\n";
	NSString* artist = @"Content-Disposition: form-data; name=\"artist\"\r\n\r\nScott Andrew";
	NSString* caption = nil;
	NSString* title = nil;
	NSString* keywords = nil;
	
	if ([imageToUpload descriptionText] != nil)
		caption = [NSString stringWithFormat:captionFormat, [imageToUpload descriptionText]];
		
	if ([imageToUpload keywords] != nil)
		keywords = [NSString stringWithFormat:keywordFormat, [imageToUpload keywords]];
	
	title = [NSString stringWithFormat:titleFormat, [imageToUpload title]];
	
	NSMutableData* data = [NSMutableData dataWithData:[boundryString dataUsingEncoding:NSISOLatin1StringEncoding]];
	bool bAllSucceded = YES;
		
	if (caption != nil)
	{
		[data appendData: [caption dataUsingEncoding:NSISOLatin1StringEncoding]];
		[data appendData: [seperator dataUsingEncoding:NSISOLatin1StringEncoding]];
	}
	
	if (title != nil)
	{
		[data appendData: [title dataUsingEncoding:NSISOLatin1StringEncoding]];
		[data appendData: [seperator dataUsingEncoding:NSISOLatin1StringEncoding]];
	}
	
	//if(keywords != nil)
	//{
	//	[data appendData: [keywords dataUsingEncoding:NSISOLatin1StringEncoding]];
	//	[data appendData: [seperator dataUsingEncoding:NSISOLatin1StringEncoding]];
	//}		
	
//			[data appendData: [artist dataUsingEncoding:NSISOLatin1StringEncoding]];
//		[data appendData: [seperator dataUsingEncoding:NSISOLatin1StringEncoding]];

	[data appendData: [content dataUsingEncoding:NSISOLatin1StringEncoding]];
	[data appendData: [NSData dataWithContentsOfFile:[imageToUpload uploadName]]];
	[data appendData: [seperator dataUsingEncoding:NSISOLatin1StringEncoding]];

	[data appendData: [command dataUsingEncoding:NSISOLatin1StringEncoding]];	
	[data appendData: [endingBoundry dataUsingEncoding:NSISOLatin1StringEncoding]];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	// we want to mark this as with the proper data formatting.. 
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	[request setHTTPBody: data];
	
	return request;
}
	

-(NSError*)prepareImage
{
	BOOL progressExists = [delegate respondsToSelector:@selector(updateFileConversionProgress:)];
	int err = SERVER_SUCCESS;
	NSError* error = nil;
	
	if (![imageToUpload isJPEG])		
	{
		if (progressExists)
		{
			[delegate performSelectorOnMainThread: @selector(updateFileConversionProgress:)
					  withObject: [NSNumber numberWithInt:upload_ImageStartConversion]
					  waitUntilDone:YES];
		}
						
		// ok we need to use the image to do some conversion work
		if (![imageToUpload doConversion])
			err = SERVER_COULD_NOT_CONVERT_TO_JPEG;				
	}
	else if ([imageToUpload isResized])
	{
		if (progressExists)
		{
			[delegate performSelectorOnMainThread: @selector(updateFileConversionProgress:)
					  withObject: [NSNumber numberWithInt:upload_ImageResizeImage]
					  waitUntilDone:YES];
		}
		
		if (![imageToUpload doConversion])
			err = SERVER_COULD_NOT_RESIZE_IMAGE;
	}
	
	if (err != SERVER_SUCCESS)
		error = [NSError withErrorCode:[NSBundle bundleForClass:[self class]] code:err argument:nil];
	else
	{
		[delegate performSelectorOnMainThread: @selector(updateFileConversionProgress:)
			withObject: [NSNumber numberWithInt:upload_ImageBegin]
			waitUntilDone:YES];
	}
		
	return error;
}

-(void)dealloc
{
	// release what we stashed
	[imageToUpload release];
	[parentGallery release];
	[userName release];
	
	// call base class.
	[super dealloc];
}

// we don't even look at what we are sent becuase we haven't done anything yet. we want to do everything on this thread so the UI
// is responsive.. So we are actually going to build a request. where we normally send. (yuk i know).
-(void)sendRequestProxy:(NSURLRequest*)request
{
//	if (autoreleasePool == nil)
//		autoreleasePool = [[NSAutoreleasePool alloc] init];

	NSError* error = [self prepareImage];
	
	// if we got an error we want to bail..
	if (error != nil)
	{
		[self setError:error];
		
		if ([delegate respondsToSelector:@selector(webRequestDidFailWithError:)])
			[delegate performSelectorOnMainThread: @selector(webRequestDidFailWithError:) withObject:self waitUntilDone:NO];
	}
	else
	{
		NSURLRequest* imgRequest = [self buildRequest];
		[super sendRequestProxy:imgRequest];
	}
	
}

-(void) doUpload:(PBImageToUpload*)image toGallery:(PBGallery*)gallery forUser:(NSString*)user
{
	imageToUpload = [image retain];
	parentGallery = [gallery retain];
	userName = [user retain];
	
	[self sendRequest:nil];
}


-(NSError*)parseRecievedData:(NSData*)data
{
	NSError* xmlError = nil;
	NSError* error = nil;
	int err = SERVER_SUCCESS;
	unsigned char* b = (unsigned char*)[data bytes];
	
	// create a tidyed up XML doc. and search for the node that has our status string.
	NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithData:data options:NSXMLDocumentTidyHTML error:&xmlError] autorelease];
	NSArray* uploadInfo = [xmlDoc nodesForXPath:@"/html/body[1]/font[1]" error:&xmlError];
	
	// if we found our node that might have our status sring then check
	// for it.
	if ([uploadInfo count] > 0)
	{
		NSXMLNode* node = [uploadInfo objectAtIndex:0];
		NSString* nodeValue = [node stringValue];
		NSRange foundRange = [nodeValue rangeOfString:@"Uploaded image:"];
		
		// if we found that we uploaded ok then we need to get the URL and stash it.
		if (foundRange.location != NSNotFound)
		{
			// get the anchor node.
			NSArray* foundAnchorNodes = [node nodesForXPath:@"a[1]" error:&xmlError];
			NSXMLElement* anchorNode = [foundAnchorNodes objectAtIndex:0];
			
			// get the href link.
			NSXMLNode* url = [anchorNode attributeForName:@"href"];
			NSString* name = [url stringValue];
			
			// stash the URL.. We need it..
			imageURL = [[NSURL URLWithString:name] retain];
		}
		else
		{
			err = SERVER_UPLOAD_FAILED;
		}
	}
	else
	{
		err = SERVER_UPLOAD_FAILED;
	}
	

	if (err != SERVER_SUCCESS)
		error = [NSError withErrorCode:[NSBundle bundleForClass:[self class]] code:err argument:nil];
	
	return error;
}

-(NSURL*)URL
{
	return imageURL;
}

@end
