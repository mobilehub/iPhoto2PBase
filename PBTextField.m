#import "PBTextField.h"

@implementation PBTextField

-(void)mouseDown:(NSEvent*)event
{
	[super mouseDown:event];
	
	[NSCursor unhide];
}
@end
