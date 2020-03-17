//
//  CCSettingWindowController.m
//  iCleaner
//
//  Created by 郭妙友 on 2019/4/11.
//  Copyright © 2019年 miaoyou.gmy. All rights reserved.
//

#import "CCSettingWindowController.h"
#import "CCUtils.h"
#import "CCleanWroker.h"

uint kCCWeedOutTimes[] = {7, 15, 30};

@interface CCSettingWindowController ()<NSTableViewDataSource,NSTableViewDelegate,NSWindowDelegate>
@property (weak) IBOutlet NSButton *checkBtn;
@property (weak) IBOutlet NSTableView *cleanPathsTableView;
@property (weak) IBOutlet NSComboBox *comboBtn;
@end

@implementation CCSettingWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.delegate = self;
    self.cleanPathsTableView.delegate = self;
    self.cleanPathsTableView.dataSource = self;
    [self setup];
    
}
- (IBAction)clickCheckBtn:(NSButton *)sender {
    CCleanWroker.defaultWorker.config.silencing = sender.state == NSOnState;
}

- (IBAction)selectWeedOutDays:(NSComboBox *)comboBox {
    CCleanWroker.defaultWorker.config.cleanDay = kCCWeedOutTimes[comboBox.indexOfSelectedItem];
}

- (IBAction)clickTroubleShoot:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://github.com/778477/iClean/wiki"];
    
    [[NSWorkspace sharedWorkspace] openURLs:@[url]
                    withAppBundleIdentifier:@"com.apple.Safari"
                                    options:NSWorkspaceLaunchDefault
             additionalEventParamDescriptor:nil
                          launchIdentifiers:nil];
}

- (void)setup{
    self.checkBtn.state = CCleanWroker.defaultWorker.config.silencing ? NSOnState : NSOffState;
    
    for(int i = 0; i<3; ++i){
        if(kCCWeedOutTimes[i] == CCleanWroker.defaultWorker.config.cleanDay){
            [self.comboBtn selectItemAtIndex:i];
            break;
        }
    }
    
}


// TODO: https://stackoverflow.com/questions/970707/cocoa-keyboard-shortcuts-in-dialog-without-an-edit-menu

- (void)detele:(id)sender{
    NSIndexSet *set = self.cleanPathsTableView.selectedRowIndexes;
    if(set.count == 0) return ;
    
    NSUInteger currentIndex = [set firstIndex];
    while (currentIndex != NSNotFound) {
        currentIndex = [set indexGreaterThanIndex:currentIndex];
    }
    
    [CCleanWroker.defaultWorker.config.cleanDirPaths removeObjectsAtIndexes:set];
    [self.cleanPathsTableView reloadData];
}

- (IBAction)enterNewCleanDirPath:(NSTextField *)sender {
    if([CCUtils isVaildDirPath:sender.stringValue]){

        [CCleanWroker.defaultWorker.config.cleanDirPaths addObject:sender.stringValue];
        [self.cleanPathsTableView reloadData];
    }
    
    [sender setStringValue:@""];
}

#pragma mark - NSWindowDelegate
- (BOOL)windowShouldClose:(NSWindow *)sender{
    return [CCleanWroker.defaultWorker.config syncSettingContentToLocalFile];
}

#pragma mark -
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return CCleanWroker.defaultWorker.config.cleanDirPaths.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"PathCellID" owner:nil];
    cell.textField.stringValue = CCleanWroker.defaultWorker.config.cleanDirPaths[row];
    return cell;
}

@end
