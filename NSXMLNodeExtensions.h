 //
//  NSXMLNodeExtensions.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 3/21/07.
//  Copyright 2007 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSXMLNode(NSXMLNodeExtension)

-(NSString*) stringFromXPath:(NSString*)path error:(NSError**)error;


@end
