//
//  CCXcodeDeviceDataMoniter.h
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline unsigned long long finderSize(NSString * _Nonnull finderPath){
    unsigned long long int fileSize = 0;
    @autoreleasepool {
        NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:finderPath error:nil];
        NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
        NSString *fileName;
        
        while (fileName = [filesEnumerator nextObject]) {
            NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[finderPath stringByAppendingPathComponent:fileName] error:nil];
            fileSize += [fileDictionary fileSize];
        }
    }
    return fileSize;
}

@class CCDerivedDataFinderModel;

@interface CCXcodeDeviceDataManager : NSObject

+ (CCXcodeDeviceDataManager *_Nonnull)shareManager;

- (void)loadDerivedDataContents:(void(^_Nonnull)(NSArray<CCDerivedDataFinderModel *> * _Nullable models,NSError * _Nullable error))handle;

@end
