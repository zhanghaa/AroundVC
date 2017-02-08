//
//  AroundVC.m
//  AroundVC
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "AroundVC.h"
#import "AroundCell.h"

@interface AroundVC ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) AroundCell *aroundCell;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic,assign) float cellLastX; //最后的cell的移动距离

@end

@implementation AroundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.tableHeaderView = self.headerView;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
    
    // 注册一个
    extern NSString *tapCellScrollNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:tapCellScrollNotification object:nil];

}

-(UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
        _headerView.backgroundColor = [UIColor colorWithRed:(float)75/255 green:(float)147/255 blue:(float)243/255 alpha:1.0];
    }
    return _headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    _aroundCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!_aroundCell) {
        _aroundCell = [[AroundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    _aroundCell.tableView = self.myTableView;
    __weak typeof(self) weakSelf = self;
    _aroundCell.tapCellClick = ^(NSIndexPath *indexPath) {
        [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    
    if (indexPath.row % 2 != 0) {
        _aroundCell.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    } else {
        _aroundCell.backgroundColor = [UIColor whiteColor];
    }
    
    return _aroundCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选中");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat lblW = self.view.bounds.size.width / 5;
    
    UILabel *titleLbl = [UILabel new];
    titleLbl.frame = CGRectMake(0, 0, lblW, 40);
    titleLbl.text = @"股票";
    titleLbl.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    titleLbl.font = [UIFont systemFontOfSize:12];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLbl];
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(lblW, 0, self.view.bounds.size.width-lblW, 40)];
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    
    NSArray *topArr = @[@"估算净值", @"估算涨幅", @"最新净值", @"日涨幅", @"操作"];
    CGFloat labelW = self.view.bounds.size.width / 5;
    [topArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(labelW * idx, 0, labelW, 40);
        label.text = topArr[idx];
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.topScrollView addSubview:label];
    }];
    self.topScrollView.contentSize = CGSizeMake(lblW * topArr.count, 0);
    self.topScrollView.delegate = self;
    
    [headerView addSubview:self.topScrollView];
    
    return headerView;
}

#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.topScrollView]) {
        CGPoint offSet = _aroundCell.rightScrollView.contentOffset;
        offSet.x = scrollView.contentOffset.x;
        _aroundCell.rightScrollView.contentOffset = offSet;
    }
    if ([scrollView isEqual:self.myTableView]) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
    }
    
}

-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    self.cellLastX = x;
    CGPoint offSet = self.topScrollView.contentOffset;
    offSet.x = x;
    self.topScrollView.contentOffset = offSet;
    obj = nil;
}

@end
