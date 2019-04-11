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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        /*NS_VALID_UNTIL_END_OF_SCOPE*/ AppDelegate *app = [[AppDelegate alloc] init];
        NSApplicationLoad();
        [NSApp setDelegate:app];
        [NSApp run];
        app = nil;
    }
    return 0;
  
}
