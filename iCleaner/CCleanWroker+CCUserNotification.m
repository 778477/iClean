//
//  CCleanWroker+CCUserNotification.m
//  iCleaner
//
//  Created by 郭妙友 on 2019/4/5.
//  Copyright © 2019年 miaoyou.gmy. All rights reserved.
//

#import "CCleanWroker+CCUserNotification.h"

@implementation CCleanWroker (CCUserNotification)

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification{
    
    if([notification.identifier isEqualToString:kCCleanNotificationAction]){
        id<CleanAppDelegate> delagete = (id<CleanAppDelegate>)[NSApplication sharedApplication].delegate;
        [delagete cleaning];
        [self weedoutIfNeed];
    }
}

@end
