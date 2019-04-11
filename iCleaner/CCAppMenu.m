//
//  CCAppMenu.m
//  iCleaner
//
//  Created by 郭妙友 on 2019/4/10.
//  Copyright © 2019年 miaoyou.gmy. All rights reserved.
//

#import "CCAppMenu.h"

@implementation CCAppMenu

NSString * AppName(){
    static NSString *appName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appName = [[NSProcessInfo processInfo] processName];
    });
    return appName;
}

+ (void)loadMenu{
    [self populateMainMenu];
}

+ (void)populateMainMenu{
    NSMenu *mainMenu = [[NSMenu alloc] initWithTitle:@"MainMenu"];
    NSMenuItem *menuItem = [mainMenu addItemWithTitle:@"Application" action:nil keyEquivalent:@""];
    NSMenu *submenu = [[NSMenu alloc] initWithTitle:@"Application"];
    [self populateApplicationMenu:submenu];
    [mainMenu setSubmenu:submenu forItem:menuItem];
    [NSApp setMainMenu:mainMenu];
}

+ (void)populateApplicationMenu:(NSMenu *)menu{
    NSString *title;
    NSMenuItem *menuItem;
    
    title = [NSString stringWithFormat:@"About %@", AppName()];
    menuItem = [menu addItemWithTitle:title action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
    menuItem.target = NSApp;
    [menu addItem:[NSMenuItem separatorItem]];
    
    
    title = [NSString stringWithFormat:@"Quit %@", AppName()];
    menuItem = [menu addItemWithTitle:title action:@selector(terminate:) keyEquivalent:@"q"];
    menuItem.target = NSApp;
}
@end
