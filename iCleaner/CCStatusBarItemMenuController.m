//
//  CCStatusBarItemMenuController.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/26.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import "CCStatusBarItemMenuController.h"

@interface CCStatusBarItemMenuController ()<NSMenuDelegate>

@end

@implementation CCStatusBarItemMenuController

- (NSMenu *)theMenu{
    if(!_theMenu){
        _theMenu = [[NSMenu alloc] initWithTitle:@"iClean"];
        _theMenu.delegate = self;
        
        NSArray<NSString *> *arr = @[@"first",@"about",@"setting",@"-",@"exit"];
        
        [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isEqualToString:@"-"]){
                [_theMenu addItem:[NSMenuItem separatorItem]];
            } else {
                NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:obj
                                                              action:NSSelectorFromString([NSString stringWithFormat:@"click%@Item",obj])
                                                       keyEquivalent:@""];
                item.tag = idx;
                [item setTarget:self];
                [_theMenu addItem:item];
            }
        }];
        
    }
    return _theMenu;
}

#pragma mark - MenuItem Action
- (void)clickaboutItem{
    NSLog(@"about");
}

- (void)clicksettingItem{
    NSLog(@"setting");
}

- (void)clickexitItem{
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
    item.title = [NSString stringWithFormat:@"当前文件系统空间大小为 %luGB 可用空间大小为 %luGB",size, freeSize];
}
@end
