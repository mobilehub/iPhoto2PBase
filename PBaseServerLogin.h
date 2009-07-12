//
//  PBaseServerLogin.h
//  iPhoto2PBase
//
//  Created by Scott Andrew on 6/19/06.
//  Copyright 2006 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncWebRequest.h"

@protocol PBaseServerLoginDelegate
-(void)loginDidBegin;
-(void)loginDidFail:(NSError*)error;
-(void)loginDidCancel;
-(void)loginDidFinish;
@end

@interface PBaseServerLogin : AsyncWebRequest 
{
	NSString* loginName;
}

-(NSError*) parseRecievedData:(NSData*)data;
-(void)login:(NSString*)username password:(NSString*)password;
-(NSString*)loginName;

@end