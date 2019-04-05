//
//  CCSetting.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2018/11/3.
//  Copyright © 2018 miaoyou.gmy. All rights reserved.
//

#import "CCSetting.h"
#import "CCUtils.h"

@implementation CCSetting{
    NSMutableArray<NSString *> *_paths;
    NSTimeInterval _weedOutInterval;
    BOOL _silencing;
}

- (instancetype)init{
    self = [super init];
    if(self){
        // TODO: load CCSetings.plist
        _weedOutInterval = ccWeedOutAWeek;
        _silencing = NO;
        _paths = @[@"/Users/miaoyou.gmy/Library/Developer/Xcode/DerivedData",
                   @"/Users/miaoyou.gmy/Documents/iCleanTestDir"].mutableCopy;
    }
    return self;
}

#pragma mark - cleanConfig
- (NSArray<NSString *> *)cleanDirPaths{
    return [_paths copy];
}

- (void)updateCleanDirPaths:(NSArray<NSString *> *)paths{
    [_paths removeAllObjects];
    for(NSString *path in paths){
        if([CCUtils isVaildDirPath:path]){
            [_paths addObject:path];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCCStartCleanNotification
                                                        object:nil];
}

- (NSTimeInterval)cleanTimeInterval{
    return _weedOutInterval;
}

- (BOOL)needWeedout{
    NSTimeInterval lastClean = [[NSUserDefaults standardUserDefaults] doubleForKey:kCCLastCleanTimeStamp];
    
    NSTimeInterval cur = [[NSDate date] timeIntervalSince1970];
    if(lastClean < 1.0 || (cur - lastClean) >= _weedOutInterval){
#ifndef DEBUG
        [[NSUserDefaults standardUserDefaults] setDouble:cur forKey:kCCLastCleanTimeStamp];
#endif
        return YES;
    }
    return NO;
}

- (BOOL)silencing{
    return _silencing;
}

#pragma mark -


/**
 持久化缓存目录到本地文件
 CCSettings.plist
 */
- (void)syncCachePathsToLocal{
    
}

@end
