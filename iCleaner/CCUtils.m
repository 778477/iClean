//
//  CCUtils.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2018/11/3.
//  Copyright © 2018 miaoyou.gmy. All rights reserved.
//

#import "CCUtils.h"

unsigned long long finderSize(NSString * _Nonnull finderPath){
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

@implementation CCUtils

+ (BOOL)isVaildDirPath:(NSString *)dirPath{
    return YES;
}

@end
