/*
 *  untils.h
 *  iPhoto2PBase
 *
 *  Created by Scott Andrew on 4/17/05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#import <cocoa/cocoa.h>

#if defined(__cplusplus)
#define FUNCTION_EXTERNAL extern "C"
#else
#define FUNCTION_EXTERNAL extern
#endif

FUNCTION_EXTERNAL NSString* PluginGetLocalizedString(NSString* key);
FUNCTION_EXTERNAL NSString* PluginGetLocalizedStringFromTable(NSString* key, NSString* table);
FUNCTION_EXTERNAL NSString* MakeStringURLEncodingFriendly(NSString* rawString);
FUNCTION_EXTERNAL NSString* BoolToYNString(bool b); 
FUNCTION_EXTERNAL NSMutableArray* CreateWebMenuArrayFromStringFile(NSString* stringFile, int count);
FUNCTION_EXTERNAL NSString* PluginGetLocalizedPathForImage(NSString* name);