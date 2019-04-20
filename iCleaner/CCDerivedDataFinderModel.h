//
//  CCDerivedDataFinderModel.h
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCDerivedDataFinderModel : NSObject

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) uint64_t contentSize;

- (instancetype)initWithFilePath:(NSString *)path
                       attribute:(NSDictionary<NSFileAttributeKey, id> *)attributes NS_DESIGNATED_INITIALIZER;

- (BOOL)isNeedWeedOut:(NSTimeInterval)interval;

@end
