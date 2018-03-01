# FJRefresh
上拉刷新与下拉加载控件

>
>利用runtime特性实现的一款简单的上拉刷新与下拉加载的控件，同时加入没有数据时可以点击的无数据提示的空白页，可自定义展示
>

![效果图](https://github.com/nuanqing/FJRefresh/blob/master/FJRefreshDemo/FJRefresh.gif)

基本使用，在控制器中添加以下代码:
```
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
```
设置无数据空白页：
```
/**
设置无数据时图片控件
*/
- (void)setUpNoDataView:(UIView *)noDataView;
```
