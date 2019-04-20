//
//  CCSetting.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2018/11/3.
//  Copyright © 2018 miaoyou.gmy. All rights reserved.
//

#import "CCSetting.h"
#import "CCUtils.h"

NSTimeInterval weedoutTimeIntervalFromDay(NSInteger day){
    if(day < 1) return ccWeedOutAWeek;
    
    return day * 24 * 60 * 60;
}

@implementation CCSetting{
    NSTimeInterval _weedOutInterval;
}
@synthesize silencing = _silencing, cleanDay = _cleanDay, cleanDirPaths = _cleanDirPaths;

- (instancetype)init{
    self = [super init];
    if(self){
        
        // load setting data from settings.plist
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"settings" withExtension:@"json"];
        NSData *data = [NSData dataWithContentsOfURL:fileUrl];
        NSDictionary *setting = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        _cleanDay = [setting[@"cleanTimeInterval"] integerValue];
        _weedOutInterval = weedoutTimeIntervalFromDay(_cleanDay);
        _silencing = [setting[@"silencing"] boolValue];
        _cleanDirPaths = [setting[@"needCleanPaths"] mutableCopy];
    }
    return self;
}

#pragma mark - cleanConfig
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


#pragma mark -


/**
 持久化缓存目录到本地文件
 CCSettings.plist
 */
- (BOOL)syncSettingContentToLocalFile{
    NSDictionary *setting = @{@"silencing": @(self.silencing),
                              @"cleanTimeInterval": @(self.cleanDay),
                              @"needCleanPaths":self.cleanDirPaths.copy
                              };
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"settings"
                                             withExtension:@"json"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:setting
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    return [data writeToURL:fileUrl atomically:YES];
}

@end
