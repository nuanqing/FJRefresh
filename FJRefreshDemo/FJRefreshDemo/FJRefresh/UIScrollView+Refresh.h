//
//  UIScrollView+Refresh.h
//  FJRefreshDemo
//
//  Created by MacBook on 2018/2/24.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJRefreshHeaderView;
@class FJRefreshFooterView;

//刷新回调
typedef void(^headerRefresh)(void);
typedef void(^footerRefresh)(void);

@interface UIScrollView (Refresh)

@property (nonatomic,copy) headerRefresh headerBlock;
@property (nonatomic,copy) footerRefresh footerBlock;


// 下拉刷新
- (void)headerRefreshWithBlock:(headerRefresh)block;
- (void)endHeaderRefresh;

// 上拉加载
- (void)footerRefreshWithBlock:(footerRefresh)block;
- (void)endFooterRefresh;

@end
