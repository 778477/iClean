//
//  CCXcodeDeviceDataMoniter.h
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CCDerivedDataFinderModel;

@interface CCXcodeDeviceDataManager : NSObject

+ (CCXcodeDeviceDataManager *_Nonnull)shareManager;

- (void)loadDerivedDataContents:(void(^_Nonnull)(NSArray<CCDerivedDataFinderModel *> * _Nullable models,NSError * _Nullable error))handle;

@end
