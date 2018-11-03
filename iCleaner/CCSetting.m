//
//  CCSetting.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2018/11/3.
//  Copyright © 2018 miaoyou.gmy. All rights reserved.
//

#import "CCSetting.h"

const NSUInteger ccWeedOutAWeek = 7;
NSString *const CCBeginWatchNewCachePath = @"CCBeginWatchNewCachePath";

@implementation CCSetting{
    NSMutableArray<NSString *> *_paths;
}

- (instancetype)init{
    self = [super init];
    if(self){
        _weedOutInterval = ccWeedOutAWeek;
        _isSilent = YES;
    }
    return self;
}

- (void)addWatchCachePath:(NSString *)path{
    if(!_paths){
        _paths = [NSMutableArray array];
    }
    
    if([self isExistPath:path]){
        [_paths addObject:path];
        [[NSNotificationCenter defaultCenter] postNotificationName:CCBeginWatchNewCachePath
                                                            object:self
                                                          userInfo:@{@"path" : path}];
        
    }
    
}

- (NSArray<NSString *> *)currentWatchingCachePaths{
    return [_paths copy];
}

- (BOOL)isExistPath:(NSString *)path{
    if(!path || path.length < 1) {
        return NO;
    }
    
    return YES;
}

- (void)syncCachePathsToLocal{
    
}

@end
