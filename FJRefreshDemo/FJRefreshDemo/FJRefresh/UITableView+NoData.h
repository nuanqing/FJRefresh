//
//  UITableView+NoData.h
//  FJRefreshDemo
//
//  Created by MacBook on 2018/2/25.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (NoData)

/**
 设置无数据时图片控件
 */
- (void)setUpNoDataView:(UIView *)noDataView;

/**
 刷新tableView
 */
- (void)FJTableViewReloadData;

@end
