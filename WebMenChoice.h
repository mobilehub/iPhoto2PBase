//
//  WebMenChoice.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 7/22/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface WebMenuChoice : NSObject 
{
	NSString* name;
	NSString* commandID;
	NSMutableArray* seperators;
}

+(id) withName:(NSString*)aName command:(NSString*)aCommand;
-(id) initWithName:(NSString*)aName command:(NSString*)aCommand;

//acessors
-(NSString*)name;
-(void)setName:(NSString*)aName;

-(NSString*)commandID;
-(void)setCommandID:(NSString*)aCommand;

-(BOOL) isEqual:(id)anObject;


@end
