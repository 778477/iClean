//
//  CCAppMenu.m
//  iCleaner
//
//  Created by 郭妙友 on 2019/4/10.
//  Copyright © 2019年 miaoyou.gmy. All rights reserved.
//

#import "CCAppMenu.h"

@implementation CCAppMenu

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
    
    title = @"About";
    menuItem = [menu addItemWithTitle:title action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
    menuItem.target = NSApp;
    [menu addItem:[NSMenuItem separatorItem]];
    
    title = @"Quit";
    menuItem = [menu addItemWithTitle:title action:@selector(terminate:) keyEquivalent:@"q"];
    menuItem.target = NSApp;
}
@end
