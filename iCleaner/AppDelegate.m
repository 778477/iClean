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
#import "CCSetting.h"
#import "CCleanWroker.h"
#import "CCAppMenu.h"


@interface AppDelegate ()
@property (nonatomic) NSStatusItem *theItem;
@property (nonatomic) NSProgressIndicator *indicator;
@property (nonatomic) CCStatusBarItemMenuController *mc;
@end

@implementation AppDelegate
@synthesize isWorking = _isWorking;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    _theItem = [bar statusItemWithLength:bar.thickness];
    [_theItem setImage:[NSImage imageNamed:@"statusbar_icon"]];
    [_theItem setMenu:self.mc.theMenu];
    
    CCSetting *defaultSetting = [[CCSetting alloc] init];
    [CCleanWroker defaultWorker].config = defaultSetting;
    [[CCleanWroker defaultWorker] startTimer];

    [CCAppMenu loadMenu];
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

- (NSProgressIndicator *)indicator{
    if(!_indicator){
        _indicator = [[NSProgressIndicator alloc] init];
        _indicator.style = NSProgressIndicatorBarStyle;
        _indicator.usesThreadedAnimation = YES;
        [_indicator sizeToFit];
    }
    return _indicator;
}


#pragma mark - CleanAppDelegate
- (void)cleaning {
    if (self.isWorking) {
        return ;
    }
    
    self.isWorking = YES;
    
    [_theItem setView:self.indicator];
    [self.indicator startAnimation:nil];
}

- (void)finish{
    if (!self.isWorking) {
        return ;
    }
    
    self.isWorking = NO;
    [_theItem setView:nil];
    [self.indicator stopAnimation:nil];
    [_theItem setImage:[NSImage imageNamed:@"statusbar_icon"]];
}

@end
