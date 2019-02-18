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
@property (nonatomic) NSStatusItem *theItem;
@property (nonatomic) CCStatusBarItemMenuController *mc;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    _theItem = [bar statusItemWithLength:bar.thickness];
    [_theItem setImage:[NSImage imageNamed:@"statusbar_icon"]];
    [_theItem setMenu:self.mc.theMenu];

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
