//
//  NSXMLNodeExtensions.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 3/21/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import "NSXMLNodeExtensions.h"


@implementation NSXMLNode(NSXMLNodeExtension)

-(NSString*) stringFromXPath:(NSString*)path error:(NSError**)error
{
	NSString* string = nil;
	NSArray* nodes = [self nodesForXPath:path error:error];
	
	if ([nodes count] > 0)
	{
		NSXMLNode* node = [nodes objectAtIndex:0];
	
		if (node != nil)
			string = [node stringValue];
	}
	
	return string;
}

@end
