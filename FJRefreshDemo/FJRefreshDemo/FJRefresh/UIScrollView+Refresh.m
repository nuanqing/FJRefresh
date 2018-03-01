//
//  UIScrollView+Refresh.m
//  FJRefreshDemo
//
//  Created by MacBook on 2018/2/24.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "FJRefreshHeaderView.h"
#import "FJRefreshFooterView.h"
#import "FJRefreshConfig.h"
#import <objc/runtime.h>

@interface UIScrollView()

@property (nonatomic,strong) FJRefreshHeaderView *headerView;
@property (nonatomic,strong) FJRefreshFooterView *footerView;

@end

@implementation UIScrollView (Refresh)

//下拉刷新
- (void)headerRefreshWithBlock:(headerRefresh)block{
    self.headerBlock = block;
    self.headerView = nil;
    if (self.headerView == nil) {
        self.headerView = [[FJRefreshHeaderView alloc]initWithFrame:CGRectMake(0, -50, FJMainScreenWidth, 50)];
    }
    [self addSubview:self.headerView];
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)endHeaderRefresh{
    self.headerView.refreshType = FJCancelRefresh;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}
//上拉加载
- (void)footerRefreshWithBlock:(footerRefresh)block{
    self.footerBlock = block;
    self.footerView = nil;
    if (self.footerView == nil) {
        self.footerView = [[FJRefreshFooterView alloc]initWithFrame:CGRectMake(0, self.contentSize.height, FJMainScreenWidth, 50)];
    }
    [self addSubview:self.footerView];
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)endFooterRefresh{
    self.footerView.loadType = FJCancelLoad;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.dragging) {//拖拽中
            if (self.contentOffset.y < 0) {//处理下拉刷新
                if (self.headerView.refreshType!=FJRefreshing) {
                    if (self.contentOffset.y <= -50.f) {
                        //将要刷新状态
                        self.headerView.refreshType = FJWillRefresh;
                    }else{
                        //取消刷新状态
                        self.headerView.refreshType = FJCancelRefresh;
                    }
                }
            }else{//处理上拉刷新
                if (self.footerView.loadType!=FJLoading) {
                    CGFloat offsetY = self.contentOffset.y;
                    CGFloat frameY = self.frame.size.height;
                    CGFloat contentY = self.contentSize.height;
                    // tableView的最低点
                    float loadY = offsetY+frameY-contentY;
                    if (frameY > contentY) {
                        //如果frameY大于contentY,直接赋值给停靠点即可
                        loadY = offsetY;
                    }
                    if (loadY > 50.f) {
                        //将要加载状态
                        self.footerView.loadType = FJWillLoad;
                    }else{
                        //取消加载状态
                        self.footerView.loadType = FJCancelLoad;
                    }
                }
                
            }
        }else if (self.headerView.refreshType == FJWillRefresh){
            //为将要刷新的状态，刷新
            self.headerView.refreshType = FJRefreshing;
            //附着内容尺寸
            self.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
            self.headerBlock();
        }else if (self.footerView.loadType == FJWillLoad){
            //为将要加载的状态，加载
            self.footerView.loadType = FJLoading;
            self.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
            self.footerBlock();
        }
    }
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.footerView) {
            CGFloat contentY = self.contentSize.height;
            float loadY = contentY;
            //修改位置
            self.footerView.frame = CGRectMake(0, loadY, FJMainScreenWidth, 50);
        }
    }
}

#pragma mark - runtime加载属性


- (void)setHeaderView:(FJRefreshHeaderView *)headerView{
    objc_setAssociatedObject(self, @selector(headerView), headerView, OBJC_ASSOCIATION_RETAIN);
}

- (FJRefreshHeaderView *)headerView{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFooterView:(FJRefreshFooterView *)footerView{
    objc_setAssociatedObject(self, @selector(footerView), footerView, OBJC_ASSOCIATION_RETAIN);
}
- (FJRefreshFooterView *)footerView{
    return objc_getAssociatedObject(self, _cmd);
}
//copy
- (void)setHeaderBlock:(headerRefresh)headerBlock{
    objc_setAssociatedObject(self, @selector(headerBlock), headerBlock, OBJC_ASSOCIATION_COPY);
}
-(headerRefresh)headerBlock{
    return objc_getAssociatedObject(self, _cmd);
}
//copy
- (void)setFooterBlock:(footerRefresh)footerBlock{
    objc_setAssociatedObject(self, @selector(footerBlock), footerBlock, OBJC_ASSOCIATION_COPY);
}
- (footerRefresh)footerBlock{
    return objc_getAssociatedObject(self, _cmd);
}


@end
