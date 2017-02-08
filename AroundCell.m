//
//  AroundCell.m
//  AroundVC
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "AroundCell.h"

@implementation AroundCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    CGFloat labelW = [UIScreen mainScreen].bounds.size.width / 5;
    
    
    
    self.nameLabel = [UILabel new];
    self.nameLabel.frame = CGRectMake(0, 0, labelW, 44);
    self.nameLabel.text = @"Title";
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
    
    self.rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(labelW, 0, [UIScreen mainScreen].bounds.size.width-labelW, 44)];
    
    NSArray *arr = @[@"1.1662", @"0.01%", @"1.5880",@"3.72%",@"购买"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(labelW * idx, 0, labelW, 44);
        label.text = obj;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self.rightScrollView addSubview:label];
    }];
    
    self.rightScrollView.showsVerticalScrollIndicator = NO;
    self.rightScrollView.showsHorizontalScrollIndicator = NO;
    self.rightScrollView.contentSize = CGSizeMake(labelW * arr.count, 0);
    self.rightScrollView.delegate = self;
    
    [self.contentView addSubview:self.rightScrollView];
    
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.rightScrollView addGestureRecognizer:tapGes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:tapCellScrollNotification object:nil];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isNotification = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 避开自己发的通知，只有手指拨动才会是自己的滚动
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification
{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    if (obj!=self) {
        _isNotification = YES;
        [_rightScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
    }else{
        _isNotification = NO;
    }
    obj = nil;
}

#pragma mark - 点击事件
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    __weak typeof (self) weakSelf = self;
    if (self.tapCellClick) {
        NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:weakSelf];
        weakSelf.tapCellClick(indexPath);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
