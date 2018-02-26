//
//  FJRefreshFooterView.m
//  FJRefreshDemo
//
//  Created by MacBook on 2018/2/24.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "FJRefreshFooterView.h"
#import "FJRefreshConfig.h"

@interface FJRefreshFooterView()

// 标题
@property (nonatomic,strong) UILabel *titleLabel;
// 图片
@property (nonatomic,strong) UIImageView *imageView;
// 菊花
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@end

@implementation FJRefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self addObserver];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageView];
    [self addSubview:self.indicatorView];
}

//通知
- (void)addObserver{
    [self addObserver:self forKeyPath:@"loadType" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loadType"]) {
        switch (self.loadType) {
            case FJWillLoad:{
               self.titleLabel.text = FJWillLoadText;
                self.imageView.hidden = NO;
                self.indicatorView.hidden = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    self.imageView.transform=CGAffineTransformMakeRotation(M_PI);
                }];
            }
                break;
            case FJLoading:{
                self.titleLabel.text = FJLoadingText;
                self.imageView.hidden = YES;
                self.indicatorView.hidden = NO;
                [self.indicatorView startAnimating];
            }
                 break;
            case FJCancelLoad:{
                self.titleLabel.text = FJCancelLoadText;
                self.imageView.hidden = NO;
                self.indicatorView.hidden = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    self.imageView.transform=CGAffineTransformMakeRotation(0);
                }];
            }
                 break;
            default:
                break;
        }
    }

}

//懒加载
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(FJMainScreenWidth/3, 0, FJMainScreenWidth/3, 50);
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = FJCancelLoadText;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.frame = CGRectMake(FJMainScreenWidth/3-30, 10, 30, 30);
        _imageView.image = [UIImage imageNamed:@"arrow"];
    }
    return _imageView;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [UIActivityIndicatorView new];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indicatorView.center = CGPointMake(FJMainScreenWidth/3-15, 25);
        _indicatorView.hidden = YES;
    }
    return _indicatorView;
}






@end
