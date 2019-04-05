//
//  CCUtils.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2018/11/3.
//  Copyright © 2018 miaoyou.gmy. All rights reserved.
//

#import "CCUtils.h"

OS_ALWAYS_INLINE uint64_t finderSize(NSString * _Nonnull finderPath){
    uint64_t fileSize = 0;
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
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    BOOL isDir;
    if ([fileManager fileExistsAtPath:dirPath isDirectory:&isDir] && isDir) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)dirFormatsize:(uint64_t)contentSize{
    NSString *f;
    double tmp = contentSize * 1.0 / (1000 * 1000 * 1000);
    
    if(tmp > 1.0){
        f = [NSString stringWithFormat:@"%.2lf GB",tmp];
    } else {
        f = [NSString stringWithFormat:@"%.2lf MB",tmp * 1000];
    }
    
    return f;
}

@end
