//
//  FJRefreshHeaderView.h
//  FJRefreshDemo
//
//  Created by MacBook on 2018/2/24.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FJRefreshType) {
    FJCancelRefresh = 0,
    FJWillRefresh = 1,
    FJRefreshing = 2
};

@interface FJRefreshHeaderView : UIView

@property (nonatomic,assign) FJRefreshType refreshType;

@end
