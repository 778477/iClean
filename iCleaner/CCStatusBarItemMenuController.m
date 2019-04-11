//
//  CCStatusBarItemMenuController.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/26.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import "CCStatusBarItemMenuController.h"
#import "CCHomeViewController.h"
#import "CCSettingWindowController.h"
#import "CCleanWroker.h"

@interface CCStatusBarItemMenuController ()<NSMenuDelegate>
@property (nonatomic) CCHomeViewController *homeVc;
@property (nonatomic) CCSettingWindowController *settingVC;
@property (nonatomic) NSWindow *aboutWindow;
@end

@implementation CCStatusBarItemMenuController

- (NSMenu *)theMenu{
    if(!_theMenu){
        _theMenu = [[NSMenu alloc] initWithTitle:@"iClean"];
        _theMenu.delegate = self;
        
        NSArray<NSString *> *items = @[@"First",@"Clean",@"Setting",@"-",@"Exit"];
        NSArray<NSString *> *titles = @[@"_",@"开始清理",@"设置",@"_",@"退出"];
        
        for(NSUInteger i = 0; i<items.count; ++i){
            
            NSString *item = items[i];
            if([item isEqualToString:@"-"]){
                [_theMenu addItem:[NSMenuItem separatorItem]];
            } else {
                SEL action = NSSelectorFromString([NSString stringWithFormat:@"click%@Item",item]);
                NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:titles[i]
                                                              action:action
                                                       keyEquivalent:@""];
                [item setTarget:self];
                [_theMenu addItem:item];
            }
        }
        
    }
    return _theMenu;
}


#pragma mark - MenuItem Action
- (void)clickCleanItem{
    [[CCleanWroker defaultWorker] startClean];
}

- (void)clickSettingItem{
    if(!_settingVC){
        _settingVC = [[CCSettingWindowController alloc] initWithWindowNibName:@"CCSettingWindowController"];
    }
    
    
    [_settingVC.window makeKeyAndOrderFront:nil];
    
}

- (void)clickExitItem{
    [[NSApplication sharedApplication].windows makeObjectsPerformSelector:@selector(close)];
    [[NSApplication sharedApplication] terminate:self];
}

#pragma mark - NSMenuDelegate
- (void)menuWillOpen:(NSMenu *)menu{
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/" error:nil];
    NSMenuItem *item = [menu itemAtIndex:0];
    // 计算存储容量， 进位换算使用 1000 而不是 1024
    NSUInteger size = [dic[NSFileSystemSize] longValue] / (1000*1000*1000);
    NSUInteger freeSize = [dic[NSFileSystemFreeSize] longValue] / (1000*1000*1000);
    
    item.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString  stringWithFormat:@"当前文件系统空间大小为 %luGB\n可用空间大小为 %luGB",size, freeSize]];
}
@end
