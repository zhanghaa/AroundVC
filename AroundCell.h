//
//  AroundCell.h
//  AroundVC
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapCellClick)(NSIndexPath *indexPath);
static NSString *tapCellScrollNotification = @"tapCellScrollNotification";

@interface AroundCell : UITableViewCell <UIScrollViewDelegate>

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIScrollView *rightScrollView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, copy) TapCellClick tapCellClick;

@end
