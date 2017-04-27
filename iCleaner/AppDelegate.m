//
//  AppDelegate.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import "AppDelegate.h"
#import "CCHomeViewController.h"
#import "CCStatusBarItemMenuController.h"

@interface AppDelegate ()
@property (nonatomic) NSWindow *window;
@property (nonatomic) CCHomeViewController *vc;
@property (nonatomic) NSStatusItem *theItem;
@property (nonatomic) CCStatusBarItemMenuController *mc;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    
    _theItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [_theItem setTitle: @"F**K"];
    [_theItem setHighlightMode:YES];
    [_theItem setMenu:self.mc.theMenu];
    
//    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(SCREEN_WIDTH - iCleanMainWindowWidth - 200, SCREEN_HEIGHT - iCleanMainWindowHeight - 10, iCleanMainWindowWidth, iCleanMainWindowHeight)
//                                              styleMask:NSWindowStyleMaskClosable | NSWindowStyleMaskTitled
//                                                backing:NSBackingStoreBuffered
//                                                  defer:true];
//    self.window.title = @"iClean";
//    self.vc = [[CCHomeViewController alloc] init];
//    [self.window.contentView addSubview:self.vc.view];
//    
//    
//    [self.window makeKeyAndOrderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - 
- (CCStatusBarItemMenuController *)mc{
    if(!_mc){
        _mc = [[CCStatusBarItemMenuController alloc] init];
    }
    return _mc;
}


@end
