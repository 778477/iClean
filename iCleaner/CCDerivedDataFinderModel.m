//
//  CCDerivedDataFinderModel.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import "CCDerivedDataFinderModel.h"
#import "CCXcodeDeviceDataManager.h"

@implementation CCDerivedDataFinderModel
- (instancetype)init{
    return [self initWithFilePath:@"unkown" attribute:@{}];
}

- (instancetype)initWithFilePath:(NSString *)path attribute:(NSDictionary<NSFileAttributeKey,id> *)attributes{
    self = [super init];
    if (self) {
        
        _path = path;
        _fileType = attributes[NSFileType];
        _fileSize = finderSize(path);
        _fileCreationDate = attributes[NSFileCreationDate];
        _fileModificationDate = attributes[NSFileModificationDate];
        _contentSize = _fileSize*1.0 / ( 1024 * 1024 * 1024);
    }
    return self;
}


- (NSString *)formatSize{
    NSString *f;
    
    if(_contentSize > 1.0){
        f = [NSString stringWithFormat:@"%.2lf GB",_contentSize];
    } else {
        f = [NSString stringWithFormat:@"%.2lf MB",_contentSize * 1024];
    }
    
    return f;
}
@end
