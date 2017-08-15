JKScrollFocus
================

JKScrollFocus,只关注轮播行为的iOS焦点图无限轮播库,UIScrollView图片无限循环滚动,不依赖第三方图片加载库,不内置PageControl与titleLabel
## 思路

本轮播只专注图片循环切换。像PageControl与标题Label个人认为不应该集成在控件中，因为每一个产品UI都是不确定的，造成大量属性只为配置他们的位置颜色等等信息，个人认为得不偿失，在暴露的外部Block中设置页面中任意PageControl与label的文字

```
[self.scrollerFocus didChangeJKScrollFocusItem:^(id item,NSInteger index) {
    News *n = item;
    NSLog(@"index:%zd",index);
    //设置标题联动
    self.scrollerFocuesLabel.text = n.title;
    self.scrolllerFocusPageControl.currentPage = index;
    //只显示3个点的PageControl
    self.scrolllerFocusPageControl2.currentPage = index%self.scrolllerFocusPageControl2.numberOfPages;
}];
```

本轮播只专注图片循环切换。不强制依赖第三方图片加载库及任何下载类，在暴露的外部Block任意指定项目中的下载器

```
[scroller downloadJKScrollFocusItem:^(id item, UIImageView *currentImageView) {
        //这里我使用SDWebImage进行加载网络图片,可以使用自己的方法
        News *n = item;
        [currentImageView sd_setImageWithURL:[NSURL URLWithString:n.imageURL] placeholderImage:nil];
    }];
```

本轮播只专注图片循环切换。所以支持在外部暴露的Block自定义切换动画。

```
[scroller animationForJKScrollFocusSwitch:^CAAnimation *(UIScrollView *scrollView, NSInteger index) {
    CATransition *animationT = [CATransition animation];
    [animationT setDuration:0.35f];
    [animationT setFillMode:kCAFillModeForwards];
    [animationT setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animationT setType:kCATransitionPush];
    [animationT setSubtype:kCATransitionFromRight];
    return animationT;
}];
```
## 演示
![](https://raw.githubusercontent.com/shaojiankui/JKScrollFocus/master/demo.gif)

## 代码添加

```
self.automaticallyAdjustsScrollViewInsets = NO;
self.navigationController.navigationBarHidden = YES;

JKScrollFocus *scroller = [[JKScrollFocus alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 120)];
//imageArray 也可以传入网络图片地址数组
//这里我使用SDWebImage进行加载网络图片,可以使用自己的方法

NSMutableArray *firstArray = [NSMutableArray array];
NSArray *imageAray = @[@"http://img.ivsky.com/img/tupian/co/201507/27/langshan-002.jpg",
                                    @"http://img.ivsky.com/img/tupian/co/201507/28/zise_de_jiegenghua-002.jpg",
                                    @"http://img.ivsky.com/img/tupian/co/201507/28/ziweihua.jpg",
                                    @"http://img.ivsky.com/img/bizhi/co/201508/23/sinbawa-002.jpg",
                                    @"http://img.ivsky.com/img/bizhi/co/201508/25/call_of_duty_online-001.jpg",
                                    @"http://img.ivsky.com/img/bizhi/co/201508/25/beginning_of_autumn-004.jpg",
                                    @"http://img.ivsky.com/img/bizhi/co/201509/24/yazuishou_boy-001.jpg",
                                    @"http://img.ivsky.com/img/tupian/co/201507/28/santo_wine-009.jpg"];
NSArray *titleArray = @[@"轮播title0",@"轮播title11",@"轮播title22",@"轮播title33", @"轮播title44",@"轮播title55",@"轮播title66",@"轮播title77"];
//造假数据
for (int i=0;i<[imageAray count];i++) {
    News *n = [[News alloc]init];
    n.imageURL = [imageAray objectAtIndex:i];
    n.title = [titleArray objectAtIndex:i];
    [firstArray addObject:n];
}

scroller.items = firstArray;
scroller.autoSwitch = YES;
scroller.interval = 3.0;

[scroller didSelectJKScrollFocusItem:^(id item,NSInteger index) {
    NSLog(@"click %ld,item:%@",index,item);
}];
[scroller downloadJKScrollFocusItem:^(id item, UIImageView *currentImageView) {
    //这里我使用SDWebImage进行加载网络图片,可以使用自己的方法
    News *n = item;
    [currentImageView sd_setImageWithURL:[NSURL URLWithString:n.imageURL] placeholderImage:nil];
}];
[scroller didChangeJKScrollFocusItem:^ (id item,NSInteger index) {
//        News *n = item;
//        NSLog(@"index:%zd",index);
}];
[scroller animationForJKScrollFocusSwitch:^CAAnimation *(UIScrollView *scrollView, NSInteger index) {
    CATransition *animationT = [CATransition animation];
    [animationT setDuration:0.35f];
    [animationT setFillMode:kCAFillModeForwards];
    [animationT setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animationT setType:kCATransitionPush];
    [animationT setSubtype:kCATransitionFromRight];
    return animationT;
}];
[self.view addSubview:scroller];

```
  
    
## XIB拖拽

```
@property (weak, nonatomic) IBOutlet JKScrollFocus *scrollerFocus;
NSMutableArray *secondArray = [NSMutableArray array];
NSArray *secondImageAray =  @[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg", @"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg"];
NSArray *secondTitleArray = @[@"轮播title0",@"轮播title11",@"轮播title22",@"轮播title33", @"轮播title44",@"轮播title55",@"轮播title66",@"轮播title77"];
//造假数据
for (int i=0;i<[secondImageAray count];i++) {
    News *n = [[News alloc]init];
    n.imageURL = [secondImageAray objectAtIndex:i];
    n.title = [secondTitleArray objectAtIndex:i];
    [secondArray addObject:n];
}
//设置pagePageControl
self.scrolllerFocusPageControl.numberOfPages = [secondArray count];
//只显示3个点的PageControl
self.scrolllerFocusPageControl2.numberOfPages = ([secondArray count]<3)?[secondArray count]:3;

self.scrollerFocus.items = secondArray;
self.scrollerFocus.autoSwitch = YES;

[self.scrollerFocus didSelectJKScrollFocusItem:^(id item,NSInteger index) {
    NSLog(@"click %ld,item:%@",index,item);
}];
[self.scrollerFocus didChangeJKScrollFocusItem:^(id item,NSInteger index) {
    News *n = item;
    NSLog(@"index:%zd",index);
    //设置标题联动
    self.scrollerFocuesLabel.text = n.title;
    self.scrolllerFocusPageControl.currentPage = index;
    //只显示3个点的PageControl
    self.scrolllerFocusPageControl2.currentPage = index%self.scrolllerFocusPageControl2.numberOfPages;
}];
[self.scrollerFocus downloadJKScrollFocusItem:^(id item, UIImageView *currentImageView) {
    News *n = item;
    currentImageView.image = [UIImage imageNamed:n.imageURL];
}];

```

## License

This code is distributed under the terms and conditions of the MIT license.