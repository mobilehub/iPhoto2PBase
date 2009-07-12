//
//  WebMenChoice.m
//  iPhoto2PBase
//
//  Created by Scott Andrew on 7/22/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import "WebMenChoice.h"


@implementation WebMenuChoice

+(id) withName:(NSString*)aName command:(NSString*)aCommand
{
	WebMenuChoice* webMenuChoice = [[WebMenuChoice alloc] initWithName:aName command:aCommand];
	
	return [webMenuChoice autorelease];
}

-(id) initWithName:(NSString*)aName command:(NSString*)aCommand
{
	if (self = [super init])
	{
		[self setName:aName];
		[self setCommandID:aCommand];
	}
	
	return self;
	
}

-(void)dealloc
{
	[name release];
	[commandID release];
	[seperators release];
	
	[super dealloc];
}

-(BOOL) isEqual:(id)anObject
{
	BOOL bIsEqual = YES;
	WebMenuChoice* otherMenu = anObject;
	
	// it is equal if the name and commad match.
	bIsEqual = ([name isEqualToString:[otherMenu name]] && [commandID isEqualToString:[otherMenu commandID]]);
}

//acessors
-(NSString*)name
{
	return name;
}

-(void)setName:(NSString*)aName
{
	[name release];
	
	name = [aName retain];
}

-(NSString*)commandID
{
	return commandID;
}

-(void)setCommandID:(NSString*)aCommand
{
	[commandID release];
	
	commandID = [aCommand retain];
}

@end