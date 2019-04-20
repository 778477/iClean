//
//  main.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "CCAppMenu.h"
#import "CCApplication.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        /*NS_VALID_UNTIL_END_OF_SCOPE*/ AppDelegate *delegate = [[AppDelegate alloc] init];
        NSApplication *app = [CCApplication sharedApplication];
        [app setDelegate:delegate];
        [app run];
        app = nil;
    }
    return 0;
  
}
