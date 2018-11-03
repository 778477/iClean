//
//  CCHomeViewController.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2017/4/20.
//  Copyright © 2017年 miaoyou.gmy. All rights reserved.
//

#import "CCHomeViewController.h"
#import "CCXcodeDeviceDataManager.h"
#import "CCDerivedDataFinderModel.h"
@interface CCHomeViewController ()
<NSTableViewDelegate,
NSTableViewDataSource,
NSComboBoxDataSource>
@property (nonatomic) NSButton *sweepBtn;
@property (nonatomic) NSScrollView *scrollView;
@property (nonatomic) NSTableView *tableView;
@property (nonatomic) NSProgressIndicator *indicator;
@property (nonatomic) NSArray<CCDerivedDataFinderModel *> *data;
@end

@implementation CCHomeViewController

- (instancetype)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)loadView{
    self.view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, iCleanMainWindowWidth, iCleanMainWindowHeight)];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor brownColor].CGColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sweepBtn];
    [self.view addSubview:self.indicator];
    [self.view addSubview:self.scrollView];
}

#pragma mark -
- (NSButton *)sweepBtn{
    if(!_sweepBtn){
        _sweepBtn = [NSButton buttonWithTitle:@"star sweep" target:self action:@selector(loadDerivedData:)];
        _sweepBtn.frame = NSMakeRect(20, iCleanMainWindowHeight - 50, 160, 30);
    }
    return _sweepBtn;
}



- (NSProgressIndicator *)indicator{
    if(!_indicator){
        _indicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(20, 20, 30, 30)];
        _indicator.style = NSProgressIndicatorSpinningStyle;
        _indicator.hidden = YES;
    }
    return _indicator;
}

- (NSScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(iCleanMainWindowWidth - 400, 0, 400, iCleanMainWindowHeight)];
        _scrollView.hasVerticalScroller = _scrollView.hasVerticalRuler = YES;
        _scrollView.hasHorizontalScroller = _scrollView.hasHorizontalRuler = NO;
        
        _tableView = [[NSTableView alloc] initWithFrame:_scrollView.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.headerView = nil;
        _scrollView.contentView.documentView = _tableView;
        
        NSTableColumn *col = [[NSTableColumn alloc] initWithIdentifier:@"col1"];
        col.minWidth = 400;
        [_tableView addTableColumn:col];
        
    }
    return _scrollView;
}

#pragma mark - Action
- (void)loadDerivedData:(id)sender{
    self.indicator.hidden = NO;
    [self.indicator startAnimation:nil];
    
    [[CCXcodeDeviceDataManager shareManager] loadDerivedDataContents:^(NSArray<CCDerivedDataFinderModel *> * _Nullable models, NSError * _Nullable error) {
        self.data = [models copy];
        
        [self.indicator stopAnimation:nil];
        self.indicator.hidden = YES;
        [self.tableView reloadData];
    }];
}

#pragma mark - NSTableViewDelegate
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTextField *cell = [tableView makeViewWithIdentifier:@"cellReuseId" owner:self];
    if(!cell){
        cell = [NSTextField labelWithString:@""];
        cell.identifier = @"cellReuseId";
        cell.selectable = cell.editable = NO;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n%@ \n%@",self.data[row].path.lastPathComponent,self.data[row].formatSize,self.data[row].fileModificationDate]  attributes:@{NSForegroundColorAttributeName:[NSColor blackColor]}];
    
    cell.placeholderAttributedString = str;
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 50.f;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger row = [[notification object] selectedRow];
    NSLog(@"%ld",row);
}



#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.data.count;
}


@end
