//
//  CCleanWroker.h
//  iCleaner
//
//  Created by 郭妙友 on 2019/4/5.
//  Copyright © 2019年 miaoyou.gmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCleanConfig.h"

@interface CCleanWroker : NSObject


+ (instancetype)defaultWorker;

- (void)loadCleanConfig:(id<CleanConfig>)config;

- (void)startClean;

- (void)weedoutIfNeed;

@end
