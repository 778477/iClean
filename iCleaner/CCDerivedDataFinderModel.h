//
//  CCDerivedDataFinderModel.h
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCDerivedDataFinderModel : NSObject

@property (nonatomic) NSString *path;
@property (nonatomic) NSString *fileType;
@property (nonatomic) unsigned long long fileSize;
@property (nonatomic) NSDate *fileModificationDate;
@property (nonatomic) NSDate *fileCreationDate;
@property (nonatomic, readonly) double contentSize;
@property (nonatomic) NSString *formatSize;

- (instancetype)initWithFilePath:(NSString *)path
                       attribute:(NSDictionary<NSFileAttributeKey, id> *)attributes NS_DESIGNATED_INITIALIZER;

@end
