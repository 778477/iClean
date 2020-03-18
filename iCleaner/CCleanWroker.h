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
@property (nonatomic, strong) id<CleanConfig> _Nullable config;

+ (instancetype _Nullable)defaultWorker;

- (void)startTimer;

- (void)startCleanFromTimer:(BOOL)fromTimer;

- (void)weedoutIfNeed;

@end
