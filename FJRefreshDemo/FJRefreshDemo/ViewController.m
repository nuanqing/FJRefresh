//
//  ViewController.m
//  FJRefreshDemo
//
//  Created by MacBook on 2018/2/24.
//  Copyright © 2018年 nuanqing. All rights reserved.
//

#import "ViewController.h"
#import "FJRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *noDataButton;
@property (nonatomic,strong) UIView *noDataView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Refresh";
    self.navigationController.navigationBar.translucent = NO;
    [self setupUI];
    [self addRefresh];
    [self addLoad];
}


- (void)setupUI{
    [self.view addSubview:self.tableView];
    [self.noDataView addSubview:self.noDataButton];
    [self.tableView setUpNoDataView:self.noDataView];
    [self.noDataButton addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
}


- (void)addData{
    for (int i=0; i<3; i++) {
        [_dataArray addObject:@"下拉刷新，上拉加载,点击加载NoDataView"];
    }
    //添加刷新与加载
    [self addRefresh];
    [self addLoad];
    [self.tableView reloadData];
}
//刷新
- (void)addRefresh{
    [self.tableView headerRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self.dataArray removeAllObjects];
            for (int i=0; i<3; i++) {
                [self.dataArray addObject:@"下拉刷新，上拉加载,点击加载NoDataView"];
            }
            [self.tableView reloadData];
            [self.tableView endHeaderRefresh];
        });
    }];
}
//加载
- (void)addLoad{
    [self.tableView footerRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            for (int i=0; i<6; i++) {
                [self.dataArray addObject:@"下拉刷新，上拉加载,点击加载NoDataView"];
            }
            [self.tableView reloadData];
            [self.tableView endFooterRefresh];
        });
    }];
}

#pragma mark - tableViewDelegate&&tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark - 懒加载


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        for (int i=0; i<3; i++) {
            [_dataArray addObject:@"下拉刷新，上拉加载,点击加载NoDataView"];
        }
    }
    return _dataArray;
}

- (UIView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[UIView alloc]init];
        _noDataView.frame = self.tableView.frame;
    }
    return _noDataView;
}

- (UIButton *)noDataButton{
    if (!_noDataButton) {
        _noDataButton = [[UIButton alloc]init];
        _noDataButton.frame = CGRectMake(0, (self.tableView.frame.size.height-30)/2, FJMainScreenWidth, 30);
        [_noDataButton setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [_noDataButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _noDataButton;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 0, FJMainScreenWidth, FJMainScreenHeight-64);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
