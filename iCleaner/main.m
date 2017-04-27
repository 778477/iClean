//
//  main.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
int main(int argc, const char * argv[]) {
    AppDelegate *app = [[AppDelegate alloc] init];
    [NSApplication sharedApplication].delegate = app;
    return NSApplicationMain(argc, argv);
}
