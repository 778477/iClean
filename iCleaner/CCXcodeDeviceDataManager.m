//
//  CCXcodeDeviceDataMoniter.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import "CCXcodeDeviceDataManager.h"
#import "CCDerivedDataFinderModel.h"

NSString *const kXcodeDerivedDataPath = @"/Developer/Xcode/DerivedData";

@implementation CCXcodeDeviceDataManager{
    BOOL _isExist;
    NSString *_derivedDataPath;
    dispatch_queue_t _ownerQueue;
}


+ (CCXcodeDeviceDataManager *)shareManager{
    static CCXcodeDeviceDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CCXcodeDeviceDataManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init{
    self = [super init];
    
    if(self){
        _ownerQueue = dispatch_queue_create("com.778477.iClean.CCXcodeDeviceDataManager.ownerQ", DISPATCH_QUEUE_SERIAL);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        if(paths.count > 0){
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSString *derivedData = [[paths objectAtIndex:0] stringByAppendingPathComponent:kXcodeDerivedDataPath];
            BOOL isDir;
            if ([fileManager fileExistsAtPath:derivedData isDirectory:&isDir] && isDir) {
                _isExist = YES;
                _derivedDataPath = derivedData;
                
            } else{
                _isExist = NO;
                _derivedDataPath = nil;
            }
        }
        
    }
    
    return self;
}



- (void)loadDerivedDataContents:(nonnull void (^)(NSArray<CCDerivedDataFinderModel *> *, NSError *))handle{
    if(!_isExist){
        NSError *err = [[NSError alloc] initWithDomain:@"loadDerivedDataContents"
                                                  code:1
                                              userInfo:@{@"reason":@"~/Library/Developer/Xcode/DerivedData not exist"}];
        handle(nil,err);
        return ;
    }
    
    dispatch_async(_ownerQueue, ^{
        NSError *error;
        NSFileManager *fileManager = [NSFileManager new];
        NSMutableArray<CCDerivedDataFinderModel *> *finders = [NSMutableArray array];
        NSArray<NSURL *> *urls = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:_derivedDataPath]
                                            includingPropertiesForKeys:nil
                                                               options:0
                                                                 error:&error];
        
        [urls enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *attributErr;
            NSDictionary<NSFileAttributeKey, id> *itemAttribut = [fileManager attributesOfItemAtPath:obj.relativePath
                                                                                               error:&attributErr];
            
            CCDerivedDataFinderModel *model = [[CCDerivedDataFinderModel alloc] initWithFilePath:obj.relativePath
                                                                                       attribute:itemAttribut];
            [finders addObject:model];
        }];
        
        [finders sortUsingComparator:^NSComparisonResult(CCDerivedDataFinderModel *obj1,CCDerivedDataFinderModel *obj2) {
            return obj1.contentSize > obj2.contentSize ? NSOrderedAscending : NSOrderedDescending;
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
           handle(finders,nil);
        });
    });
}
@end
