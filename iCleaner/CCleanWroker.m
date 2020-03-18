//
//  CCleanWroker.m
//  iCleaner
//
//  Created by 郭妙友 on 2019/4/5.
//  Copyright © 2019年 miaoyou.gmy. All rights reserved.
//

#import "CCleanWroker.h"
#import "CCUtils.h"
#import "CCDerivedDataFinderModel.h"
#import "CCleanWroker+CCUserNotification.h"

const uint32_t kCleanWokerTimerOnce = 60; // 1 min
const uint32_t kCleanWokerTimerTotal = 60 * kCleanWokerTimerOnce; // 1 hour

@interface CCleanWroker()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSArray<CCDerivedDataFinderModel *> *needWeedoutDirs;
@end

@implementation CCleanWroker{
    uint32_t _timerInterval;
    dispatch_source_t _timer;
}

+ (instancetype)defaultWorker{
    static CCleanWroker *worker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        worker = [[CCleanWroker alloc] init];
    });
    return worker;
}

- (instancetype)init{
    self = [super init];
    if(self){
        [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;
    }
    return self;
}

- (dispatch_queue_t)queue{
    if(!_queue){
        _queue = dispatch_queue_create("com.miaoyou.cleanworker", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
}

- (void)resumeTimer{
    if(!_timer){
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
        
        dispatch_source_set_timer(_timer,
                                  dispatch_walltime(NULL, 0),
                                  kCleanWokerTimerOnce * NSEC_PER_SEC,
                                  0);
        if(_timer){
            _timerInterval = 0;
            dispatch_source_set_event_handler(_timer, ^{
                self->_timerInterval += kCleanWokerTimerOnce;
                if(self->_timerInterval > kCleanWokerTimerTotal){
                    self->_timerInterval = 0;
                    [self startCleanFromTimer:YES];
                }
            });
        }
    }
    
    
    if(_timer){
        dispatch_resume(_timer);
    }
}

#pragma mark - public

- (void)startTimer{
    if(!_timer){
        [self resumeTimer];
    }
    [self startCleanFromTimer:YES];
}


- (void)startCleanFromTimer:(BOOL)fromTimer{
    if (fromTimer && ![_config needWeedout]) {
        return ;
    }
    
    id<CleanAppDelegate> delagete = (id<CleanAppDelegate>)[NSApplication sharedApplication].delegate;
    [delagete cleaning];
    [self startSweepsFileTargetsCompletion:^{
        [delagete finish];
    }];
}

- (void)weedoutIfNeed {
    dispatch_async(self.queue, ^{
        uint64_t cleanedConentSize = 0;
        NSFileManager *fileManaager = [NSFileManager defaultManager];
        for(CCDerivedDataFinderModel *dir in self.needWeedoutDirs){
            if([fileManaager removeItemAtPath:dir.path error:nil]){
                cleanedConentSize += dir.contentSize;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *log = [NSString stringWithFormat:@"已清理大约 %@ 磁盘空间",[CCUtils dirFormatsize:cleanedConentSize]];
            NSUserNotification *notif = [[NSUserNotification alloc] init];
            notif.title = @"iCleaner";
            notif.informativeText = log;
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
            
            id<CleanAppDelegate> delagete = (id<CleanAppDelegate>)[NSApplication sharedApplication].delegate;
            [delagete finish];
        });
    });
}

#pragma mark - private

- (void)startSweepsFileTargetsCompletion:(dispatch_block_t)completion {
    // do the job
    dispatch_async(self.queue, ^{
        
        NSFileManager *fileManager = [NSFileManager new];
        NSError *error;
        NSMutableArray<CCDerivedDataFinderModel *> *finders = [NSMutableArray array];
        uint64_t needWeedOutConentSize = 0;
        
        for(NSString *path in self.config.cleanDirPaths){
            
            NSArray<NSURL *> *urls = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:path]
                                                includingPropertiesForKeys:nil
                                                                   options:0
                                                                     error:&error];
            
            if(error) continue;
            
            for(NSURL *url in urls){
                NSError *attributErr;
                NSString *filePath = url.relativePath;
                NSDictionary<NSFileAttributeKey, id> *itemAttribut = [fileManager attributesOfItemAtPath:filePath
                                                                                                   error:&attributErr];
                CCDerivedDataFinderModel *model = [[CCDerivedDataFinderModel alloc] initWithFilePath:filePath
                                                                                           attribute:itemAttribut];
                if([model isNeedWeedOut:self.config.cleanTimeInterval]){
                    [finders addObject:model];
                    needWeedOutConentSize += model.contentSize;
                }
            }
            
        }
        
        // 小于10MB 忽略清理
        if(needWeedOutConentSize < 10 * 1000 * 1000){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSUserNotification *notif = [[NSUserNotification alloc] init];
                notif.soundName = NSUserNotificationDefaultSoundName;
                notif.title = @"iCleaner";
                notif.informativeText = @"目标文件夹内容小于10MB,未触发清理";
                [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
            });
            
            if (completion) {
                completion();
            }
            
            return ;
        }
        
        
        self.needWeedoutDirs = finders.copy;
        if(!self.config.silencing){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSUserNotification *notif = [[NSUserNotification alloc] init];
                notif.identifier = kCCleanNotificationAction;
                notif.soundName = NSUserNotificationDefaultSoundName;
                notif.title = @"iCleaner";
                notif.informativeText = [NSString stringWithFormat:@"已扫描出目标文件夹大约有 %@ 大小待清理",[CCUtils dirFormatsize:needWeedOutConentSize]];
                [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
            });
            
            if (completion) {
                completion();
            }
        }
        
    });
    
}


@end
