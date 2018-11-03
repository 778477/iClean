//
//  CCUtils.h
//  iCleaner
//
//  Created by miaoyou.gmy on 2018/11/3.
//  Copyright © 2018 miaoyou.gmy. All rights reserved.
//

#import <Foundation/Foundation.h>

unsigned long long finderSize(NSString * _Nonnull finderPath) OS_ALWAYS_INLINE;

NS_ASSUME_NONNULL_BEGIN

@interface CCUtils : NSObject

+ (BOOL)isVaildDirPath:(NSString *)dirPath;

@end

NS_ASSUME_NONNULL_END
