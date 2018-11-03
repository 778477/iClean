//
//  CCSetting.h
//  iCleaner
//
//  Created by miaoyou.gmy on 2018/11/3.
//  Copyright © 2018 miaoyou.gmy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const CCBeginWatchNewCachePath;


@interface CCSetting : NSObject


/**
 清理陈腐缓存周期，默认初始化值为 7天
 
 @discuss 参数以天为单位
 */
@property (nonatomic, assign) NSUInteger weedOutInterval;


/**
 是否静默模式，默认为YES
 
 @discucc 打开静默之后，自动清理缓存文件，并以通知形式告知用户节省了多少磁盘空间
 */
@property (nonatomic, assign) BOOL isSilent;


/**
 添加扫描缓存目录

 @param path 缓存目录路径
 */
- (void)addWatchCachePath:(NSString *)path;



/**
 当前有效的缓存目录路径

 @return 缓存目录路径
 */
- (NSArray<NSString *> *)currentWatchingCachePaths;


/**
 持久化缓存目录到本地文件
    ~/.iclean_caches.c4
 */
- (void)syncCachePathsToLocal;

@end

NS_ASSUME_NONNULL_END
