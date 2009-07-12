/*
 *  untils.h
 *  iPhoto2PBase
 *
 *  Created by Scott Andrew on 4/17/05.
 *  Copyright 2005 New Wave Digital Media. All rights reserved.
 *
 */

#import "utils.h"
#import "PBaseExporter.h"
#import "WebMenChoice.h"

NSString* PluginGetLocalizedString(NSString* key)
{
    return [[NSBundle bundleForClass:[PBaseExporter class]] localizedStringForKey:key value:@"" table:nil];
}

NSString* PluginGetLocalizedPathForImage(NSString* name)
{
	return  [[NSBundle bundleForClass:[PBaseExporter class]]pathForImageResource:name];
}


NSString* PluginGetLocalizedStringFromTable(NSString* key, NSString* table)
{
    return [[NSBundle bundleForClass:[PBaseExporter class]] localizedStringForKey:key value:@"" table:table];
}

NSString* MakeStringURLEncodingFriendly(NSString* rawString)
{
	NSMutableString* finalString = [[NSMutableString alloc] init];
	
	if (rawString != nil)
	{
		int len = [rawString length];
		int currentChar = 0;
	
		for (currentChar; currentChar < len; currentChar++)
		{
			NSString* asciiCode;
			unichar character = [rawString characterAtIndex:currentChar];
		
			switch(character)
			{
				case ' ':
					[finalString appendString:@"+"];
					break;
                
				case '@':
				case '\"':
				case '\'':
				case '$':
				case '%':
				case '^':
				case '#':
				case '(':
				case ')':
				case '!':
				case '+':
				case '<':
				case '>':
				case '?':
				case '=':
				case ',':
				case ';':
				case '~':
				case '`':
				case '/':
				case 0x5c:
				case '{':
				case '}':
				case '|':
					asciiCode = [[[NSString alloc]initWithFormat:@"\%2x", character] autorelease];
					[finalString appendString:@"%"];
					[finalString appendString:asciiCode];
					break;
				
				default:
					if (character > 127)
					{
						asciiCode = [[[NSString alloc]initWithFormat:@"\%2x", character] autorelease];
						[finalString appendString:@"%"];
						[finalString appendString:asciiCode];				
					}
					else
					{
						asciiCode = [[[NSString alloc] initWithCharacters:&character length:1] autorelease];
						[finalString appendString:asciiCode];
					}
				
					break;
			}
			 
		}
	}
	
	return [finalString autorelease];	
}

NSString* BoolToYNString(bool b)
{
    if (b == true)
        return @"Y";
    
    return @"N";
}

NSMutableArray* CreateWebMenuArrayFromStringFile(NSString* stringFile, int count)
{
    int n = 0;
    
	NSMutableArray* menuItems = [NSMutableArray array];	
	
    
	for (n = 0; n < count; n++)
	{
		NSString* command = [NSString stringWithFormat:@"%d", n];
		NSString* commandAndID = PluginGetLocalizedStringFromTable(command, stringFile);
		
		// split the string.
		NSArray* menuCommandItems = [commandAndID componentsSeparatedByString:@","];
		
		// if we have 2 items than we are set to go.
		if ([menuCommandItems count] == 2)
		{
			WebMenuChoice* item = [WebMenuChoice withName:[menuCommandItems objectAtIndex:1] command:[menuCommandItems objectAtIndex:0]];
			
			[menuItems addObject:item];
		}
	}
    
    return menuItems;
    
}