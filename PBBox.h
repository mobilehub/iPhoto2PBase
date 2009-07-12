//
//  PBBox.h
//  IPhoto2PBase
//
//  Created by Scott Andrew on 3/23/05.
//  Copyright 2005 New Wave Digital Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ExportPluginBoxProtocol
- (BOOL)performKeyEquivalent:(id)fp12;
@end

@interface PBBox : NSBox<ExportPluginBoxProtocol>
{
	id m_Plugin;
}

@end
