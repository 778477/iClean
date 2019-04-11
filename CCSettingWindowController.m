//
//  CCSettingWindowController.m
//  iCleaner
//
//  Created by 郭妙友 on 2019/4/11.
//  Copyright © 2019年 miaoyou.gmy. All rights reserved.
//

#import "CCSettingWindowController.h"
#import "CCUtils.h"

int kCCWeedOutTimes[] = {7, 15, 30};

@interface CCSettingWindowController ()<NSTableViewDataSource,NSTableViewDelegate>
@property (weak) IBOutlet NSButton *checkBtn;
@property (weak) IBOutlet NSTableView *cleanPathsTableView;

@end

@implementation CCSettingWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.cleanPathsTableView.delegate = self;
    self.cleanPathsTableView.dataSource = self;
    
}
- (IBAction)clickCheckBtn:(NSButton *)sender {
    NSLog(@"currnt check state = %d", (int)sender.state);
}

- (IBAction)selectWeedOutDays:(NSComboBox *)comboBox {
    NSLog(@"select weedout time = %d", kCCWeedOutTimes[[comboBox indexOfSelectedItem]]);
}

- (IBAction)clickTroubleShoot:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://github.com/778477/iClean/wiki"];
    
    [[NSWorkspace sharedWorkspace] openURLs:@[url]
                    withAppBundleIdentifier:@"com.apple.Safari"
                                    options:NSWorkspaceLaunchDefault
             additionalEventParamDescriptor:nil
                          launchIdentifiers:nil];
}

// TODO: https://stackoverflow.com/questions/970707/cocoa-keyboard-shortcuts-in-dialog-without-an-edit-menu
- (IBAction)enterNewCleanDirPath:(NSTextField *)sender {
    if([CCUtils isVaildDirPath:sender.stringValue]){
        NSLog(@"get a new water clean dirPath : %@",sender.stringValue);
    }
    
    
    
    [sender setStringValue:@""];
    [self.cleanPathsTableView reloadData];
}

#pragma mark -
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 3;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"PathCellID" owner:nil];
    cell.textField.stringValue = [NSString stringWithFormat:@"row %@",@(row).stringValue];
    return cell;
}

@end
