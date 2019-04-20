//
//  CCleanConfig.h
//  iCleaner
//
//  Created by 郭妙友 on 2019/4/5.
//  Copyright © 2019年 miaoyou.gmy. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSTimeInterval ccWeedOutAWeek = 7 * 24 * 60 * 60;

static NSString *const kCCLastCleanTimeStamp = @"kCCLastCleanTimeStamp";
static NSString *const kCCStartCleanNotification = @"kCCStartCleanNotification";
static NSString *const kCCleanNotificationAction = @"kCCleanNotificationAction";

@protocol CleanAppDelegate <NSObject>

- (void)cleaning;

- (void)finish;

@end


@protocol CleanConfig <NSObject>
/**
 是否静默模式，默认为YES
 
 @discucc 打开静默之后，自动清理缓存文件，并以通知形式告知用户节省了多少磁盘空间
 */
@property (nonatomic, assign) BOOL silencing;
@property (nonatomic, assign) NSInteger cleanDay;
@property (nonatomic, strong) NSMutableArray<NSString *> *cleanDirPaths;


/**
 间隔时间 默认为 7天
 
 @return 上次清理间隔时间
 */
- (NSTimeInterval)cleanTimeInterval;



- (BOOL)needWeedout;

- (BOOL)syncSettingContentToLocalFile;


@end
