//
//  FJRefreshFooterView.h
//  FJRefreshDemo
//
//  Created by MacBook on 2018/2/24.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FJLoadType) {
    FJCancelLoad = 0,
    FJWillLoad = 1,
    FJLoading = 2,
};

@interface FJRefreshFooterView : UIView

@property (nonatomic,assign) FJLoadType loadType;

@end
