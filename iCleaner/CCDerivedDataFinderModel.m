//
//  CCDerivedDataFinderModel.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import "CCDerivedDataFinderModel.h"
#import "CCXcodeDeviceDataManager.h"
#import "CCUtils.h"

@implementation CCDerivedDataFinderModel{
    NSDate *_fileModificationDate;
    NSDate *_fileCreationDate;
    NSString *_fileType;
    uint64_t _contentSize;
}
- (instancetype)init{
    return [self initWithFilePath:@"unkown" attribute:@{}];
}

- (instancetype)initWithFilePath:(NSString *)path attribute:(NSDictionary<NSFileAttributeKey,id> *)attributes{
    self = [super init];
    if (self) {
        _path = path;
        _fileType = attributes[NSFileType];
        _contentSize = finderSize(path);
        _fileCreationDate = attributes[NSFileCreationDate];
        _fileModificationDate = attributes[NSFileModificationDate];
    }
    return self;
}

- (BOOL)isNeedWeedOut:(NSTimeInterval)interval{
    
    if(NSDate.date.timeIntervalSince1970 - _fileModificationDate.timeIntervalSince1970 >= interval){
        return YES;
    }
    
    return NO;
}

@end
