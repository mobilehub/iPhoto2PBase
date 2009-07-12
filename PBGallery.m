//
//  PBGallery.m
//  HTML Test
//
//  Created by Scott Andrew on 3/22/05.
//  Copyright 2005 New Wave Digital Media. All rights reserved.
//

#import "PBGallery.h"
#import "WebMenChoice.h"
#import "PBaseConstants.h"

@implementation PBGallery

-(id)init
{
	if (self = [super init])
	{
		name = nil;
		number = nil;
		title = nil;
		isPublic = true;
		description = nil;
		
        columns = @"4";
		tableWidth = @"50";
		cellSpacing = @"15";
		cellPadding = @"15";
        imagesPerPage = @"12";
        oldMaxImagesPerPage = @"15";
        
        enableVoting = true;
		displayExif = true;
        linkedSubgalleries = false;
        showTitles = true;
		
        showImageCaptions = false;
		styleSheet = nil;
		
		isChild = false;
		parentGallery = nil;
		
		backgroundColor = [[NSColor whiteColor] retain];
		foregroundColor = [[NSColor blackColor] retain];
		
		copyrightStatement = @"";
	}
	
	return self;
}

+(id)galleryWithXMLNode:(NSXMLNode*)node
{
	PBGallery* gallery = [[PBGallery alloc] initWithXMLNode:node];
	
	return [gallery autorelease];
}

-(id)initWithXMLNode:(NSXMLNode*)node
{
	if ([self init] != nil)
	{
		NSArray* childrenNodes = [node children];
		NSEnumerator* enumerator = [childrenNodes objectEnumerator];
		NSXMLNode* childNode;
	
		while (childNode = [enumerator nextObject])
		{
			if ([[childNode name] caseInsensitiveCompare:@"id"] == NSOrderedSame)
				[self setNumber:[childNode stringValue]];
			else if ([[childNode name] caseInsensitiveCompare:@"name"] == NSOrderedSame)
				[self setName:[childNode stringValue]];
			else  if ([[childNode name] caseInsensitiveCompare:@"title"] == NSOrderedSame)
				[self setTitle:[childNode stringValue]];
			else  if ([[childNode name] caseInsensitiveCompare:@"public_flag"] == NSOrderedSame)
			{
				bool galleryIsPublic = [[childNode stringValue] caseInsensitiveCompare:@"Y"] == NSOrderedSame;
				
				[self setIsPublic:galleryIsPublic];
			}
				
		}
	}
	
	return self;
}

-(id)initWithData:(NSString*)anID name:(NSString*)aName title:(NSString*)aTitle isPublic:(bool)isItPublic
{
	[self init];
	
	number = anID;
	name = aName;
	title = aTitle;
	isPublic = isItPublic;
	
	return self;
}

-(void) dealloc
{
	[name release];
	[title release];
	
	[super dealloc];
}

-(NSString*) name
{
	return name;
}

-(NSString*) number
{
	return number;
}

-(NSString*) title
{
	if ([title length] == 0)
		return name;
	else
		return title;
}

-(bool) isPublic
{
	return isPublic;
}

-(void) setName:(NSString*)newName;
{
	[name autorelease];
	
	name = [newName retain];
}

-(void) setNumber:(NSString*)newNumber
{
	[number autorelease];
	
	number = [newNumber retain];
}

-(void) setTitle:(NSString*)newTitle
{
	[title autorelease];
	
	title = [newTitle retain];
	
	if (name == nil)
		[self setName:[self createValidGalleryName:title]];
}

-(void) setIsPublic:(bool)goingPublic
{
	isPublic = goingPublic;
}

-(NSString*) createValidGalleryName:(NSString*)rawString
{
	NSMutableString* finalString = [[NSMutableString alloc] init];
	int len = [rawString length];
	int currentChar = 0;
	
	for (currentChar; currentChar < len; currentChar++)
	{
		NSString* asciiCode;
		unichar character = [rawString characterAtIndex:currentChar];
		
		if (character >= '0' && character <= '9')
			[finalString appendFormat:@"%C", character];
		else if (character >= 'A' && character <= 'Z')
			[finalString appendFormat:@"%C", character+32];
		else if (character >= 'a' && character <= 'z')
			[finalString appendFormat:@"%C", character];
		else if (character == '_')
			[finalString appendFormat:@"%C", character];
		else if (character == ' ')
			[finalString appendFormat:@"%C", '_'];
	}
	
	if ([finalString length] == 0)
	{	
		[finalString release];
		finalString = nil;
	}
	
	return finalString;
	
}

-(void) setDescription:(NSString*)newDescription
{
	[description autorelease];
	
	description = [newDescription retain];
}

-(NSString*) description
{
	return description;
}

-(NSColor*) foregroundColor
{
	return foregroundColor;
}

-(NSColor*) backgroundColor
{
	return backgroundColor;
}

-(bool) enableVoting
{
	return enableVoting;
}

-(bool) displayExif
{
	return displayExif;
}

-(bool) linkedSubgalleries
{
	return linkedSubgalleries;
}

-(NSString*) copyrightStatement
{
	return copyrightStatement;
}

-(bool) showImageCaptions;
{
	return showImageCaptions;
}

-(void) setForegoundColor:(NSColor*)aColor
{
	[foregroundColor autorelease];
	
	foregroundColor = [aColor retain];
}

-(void) setBackgroundColor:(NSColor*)aColor;
{
	[backgroundColor autorelease];
	
	backgroundColor = [aColor retain];
}

-(void) setEnalbeVoting:(bool)bEnableVoting
{
	enableVoting = bEnableVoting;
}

-(void) setDisplayExif:(bool)bDisplayExif
{
	displayExif = bDisplayExif;
}

-(void) setLinkedSubgalleries:(bool)bLinked
{
	linkedSubgalleries = bLinked;
}

-(void) setCopyrightStatement:(NSString*)statement
{
	[copyrightStatement autorelease];
	
	copyrightStatement = [statement retain];
}

-(void) setShowImageCaptions:(bool)bShowImageCaptions
{
	showImageCaptions = bShowImageCaptions;
}

-(NSString*) foregroundColorAsString;
{
	return [self colorAsString:[self foregroundColor]];
}

-(NSString*) backgroundColorAsString;
{
	return [self colorAsString:[self backgroundColor]];
}

-(NSString*) colorAsString:(NSColor*)color
{
	float    red, green, blue;
	  
	[[color colorUsingColorSpaceName: NSCalibratedRGBColorSpace]
	       	getRed: &red 
			green: &green 
			blue: &blue 
			alpha: nil];

	   return [NSString stringWithFormat: @"%02X%02X%02X", 
						(unsigned)(red*255), 
						(unsigned)(green*255), 
						(unsigned)(blue*255)];
}

-(WebMenuChoice*) styleSheet
{
	return styleSheet;
}

-(void) setStyleSheet:(WebMenuChoice*)style
{
	[styleSheet autorelease];
	
	styleSheet = [style retain];
}

-(WebMenuChoice*) country
{
    return country;
    
}


-(WebMenuChoice*) alignment
{
    return alignment;
}

-(void) setAlignment:(WebMenuChoice*)anAlignment
{
    [alignment autorelease];
    
    alignment = [anAlignment retain];
}

-(WebMenuChoice*) whoCanComment
{
    return whoCanComment;
}

-(void) setWhoCanComment:(WebMenuChoice*)who
{
    [whoCanComment autorelease];
    
    whoCanComment = who;
}

-(void) setCountry:(WebMenuChoice*)aCountry
{
    [country autorelease];
    
    country = [aCountry retain];
}

-(NSString*) columns
{
	return columns;
}

-(void) setColumns:(NSDecimalNumber*)columnCount
{
	[columns autorelease];
	
	columns = [[columnCount stringValue] retain];
}

-(NSString*) tableWidth
{
	return tableWidth;
}

-(void) setTableWidth:(NSDecimalNumber*)width
{
	[tableWidth autorelease];
	
	tableWidth = [[width stringValue] retain];
}

-(NSString*) cellSpacing
{
	return cellSpacing;
}

-(void) setCellSpacing:(NSDecimalNumber*)spacing
{
	[cellSpacing autorelease];
	
	cellSpacing = [[spacing stringValue] retain];
}

-(NSString*) cellPadding
{
    return cellPadding;
}

-(void) setCellPadding: (NSDecimalNumber*)padding
{
    [cellPadding autorelease];
    
    cellPadding = [[padding stringValue] retain];
}

-(NSString*) imagesPerPage
{
    return imagesPerPage;
}

-(void) setImagesPerPage:(NSDecimalNumber*)images
{
    [imagesPerPage autorelease];
    
    imagesPerPage = [[images stringValue] retain];
}

-(bool) showTitles
{
	return showTitles;
}

-(void) setShowTitles:(bool)show
{
	showTitles = show;
}

-(void) setParentGallery:(PBGallery*)aGallery
{
	[parentGallery release];
	
	parentGallery = [aGallery retain];
}

-(PBGallery*) parentGallery
{
	return parentGallery;
}

-(bool) isChild
{
	return isChild;
}

-(void) setIsChild:(bool)child
{
	isChild = child;
}

-(NSString*) HTMLData
{
    NSString* htmlString = [NSString stringWithFormat: pbaseGalleryDetails,
                                                       name,
                                                       MakeStringURLEncodingFriendly(title),
                                                       MakeStringURLEncodingFriendly(description),
                                                       [country commandID],
													   BoolToYNString(showTitles),
                                                       BoolToYNString(isPublic),
                                                       columns,
                                                       tableWidth,
                                                       cellSpacing,
                                                       cellPadding,
                                                       oldMaxImagesPerPage,
                                                       imagesPerPage,
                                                       [self backgroundColorAsString],
                                                       [self foregroundColorAsString],
                                                       [styleSheet commandID],
													   number];
													   
	return htmlString;
        
                                                       
}

-(NSString*) HTMLAdvancedData
{
    NSString* htmlString = [NSString stringWithFormat: pbaseGalleryAdvanced,
                                                       BoolToYNString(enableVoting),
                                                       BoolToYNString(displayExif),
                                                       [whoCanComment commandID],
													   copyrightStatement,
													   BoolToYNString(showImageCaptions),
													   [alignment commandID],
                                                       BoolToYNString(linkedSubgalleries)];
													   
	return htmlString;
        
                                                       
}

@end

