//
//  UITableView+NoData.m
//  FJRefreshDemo
//
//  Created by MacBook on 2018/2/25.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "UITableView+NoData.h"
#import <objc/runtime.h>

@interface UITableView ()

@property (nonatomic,strong) UIView *noDataView;
@end


@implementation UITableView (NoData)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //方法交换
        Method method1 = class_getInstanceMethod(self, @selector(reloadData));
        Method method2 = class_getInstanceMethod(self, @selector(FJTableViewReloadData));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)setUpNoDataView:(UIView *)noDataView{
    if (self.noDataView) {
        self.noDataView = nil;
    }
    self.noDataView = noDataView;
}

- (void)FJTableViewReloadData{
    [self FJTableViewReloadData];
    id<UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 0;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self];
    }
    for (NSInteger i = 0; i <= sections; ++i) {
        NSInteger rows = [dataSource tableView:self numberOfRowsInSection:sections];
        if (!rows) {
            if (self.tableHeaderView) {
                CGFloat y = self.tableHeaderView.frame.size.height;
                self.noDataView.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height-y);
                self.scrollEnabled = YES;
            }else{
                self.scrollEnabled = NO;
            }
            //移除下拉刷新与加载
             [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self addSubview:self.noDataView];
        }else{
            self.scrollEnabled = YES;
            if (self.noDataView) {
                [self.noDataView removeFromSuperview];
            }
        };
    }
}


// 利用runtime添加属性
- (void)setNoDataView:(UIView *)noDataView{
    objc_setAssociatedObject(self, @selector(noDataView), noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)noDataView{
    return objc_getAssociatedObject(self, _cmd);
}

@end
