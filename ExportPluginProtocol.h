#include <Cocoa/Cocoa.h>
#import "ExportMgr.h"

@protocol ExportPluginProtocol
- (id)initWithExportImageObj:(id <ExportImageProtocol>)fp12;
- (id)settingsView;
- (id)firstView;
- (id)lastView;
- (void)viewWillBeActivated;
- (void)viewWillBeDeactivated;
- (id)requiredFileType;
- (BOOL)wantsDestinationPrompt;
- (id)getDestinationPath;
- (id)defaultFileName;
- (id)defaultDirectory;
- (BOOL)treatSingleSelectionDifferently;
- (BOOL)validateUserCreatedPath:(id)fp12;
- (void)clickExport;
- (void)startExport:(id)fp12;
- (void)performExport:(id)fp12;
- (void *)progress;
- (void)lockProgress;
- (void)unlockProgress;
- (void)cancelExport;
- (id)name;
- (id)description;
- (NSString *)imageTitleAtIndex:(unsigned)index;
@end
