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
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) id<CleanConfig> config;
@property (nonatomic, strong) NSArray<CCDerivedDataFinderModel *> *needWeedoutDirs;
@end

@implementation CCleanWroker{
    uint32_t _timerInterval;
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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startCleanIfNeed)
                                                     name:kCCStartCleanNotification
                                                   object:nil];
    }
    return self;
}

- (dispatch_queue_t)queue{
    if(!_queue){
        _queue = dispatch_queue_create("com.miaoyou.cleanworker", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
}

- (dispatch_source_t)timer{
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
                    [self startCleanIfNeed];
                }
            });
        }
    }
    return _timer;
}

#pragma mark - public
- (void)loadCleanConfig:(id<CleanConfig>)config{
    _config = config;
}

- (void)startClean{
    dispatch_resume(self.timer);
    [self startCleanIfNeed];
}

- (void)weedoutIfNeed{
    dispatch_async(self.queue, ^{
        uint64_t cleanedConentSize = 0;
        NSFileManager *fileManaager = [NSFileManager defaultManager];
        for(CCDerivedDataFinderModel *dir in self.needWeedoutDirs){
            if([fileManaager removeItemAtPath:dir.path error:nil]){
                cleanedConentSize += dir.contentSize;
            }
        }
        
        
        NSString *log = [NSString stringWithFormat:@"已扫描出目标文件夹大约有 %@ 大小待清理",[CCUtils dirFormatsize:cleanedConentSize]];
        NSLog(@"%@", log);
        
        NSUserNotification *notif = [[NSUserNotification alloc] init];
        notif.identifier = kCCleanNotificationAction;
        notif.title = @"iCleaner";
        notif.informativeText = log;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
        
        id<CleanAppDelegate> delagete = (id<CleanAppDelegate>)[NSApplication sharedApplication].delegate;
        dispatch_async(dispatch_get_main_queue(), ^{
            [delagete finish];
        });
    });
}

#pragma mark - private

- (void)startCleanIfNeed{
    if(![_config needWeedout]){
        return ;
    }
    
    NSUserNotification *notif = [[NSUserNotification alloc] init];
    notif.hasActionButton = NO;
    notif.title = @"iCleaner";
    notif.informativeText = @"开始检查目标缓存文件夹是否需要清理";
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
    
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
                NSLog(@"start scan %@",filePath);
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
            NSLog(@"less than 10MB, Pass");
            return ;
        }
        
        NSLog(@"greater than 10MB, need clean!");
        self.needWeedoutDirs = finders.copy;
        if(!self.config.silencing){
            NSUserNotification *notif = [[NSUserNotification alloc] init];
            notif.identifier = kCCleanNotificationAction;
            notif.title = @"iCleaner";
            notif.informativeText = [NSString stringWithFormat:@"已扫描出目标文件夹大约有 %@ 大小待清理",[CCUtils dirFormatsize:needWeedOutConentSize]];
            notif.actionButtonTitle = @"clean";
            notif.otherButtonTitle = @"ignore";
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
        }
        
    });
    
}


@end
