JKScrollFocus
================

JKScrollFocus,ios 焦点图轮播,UIScrollView图片无限循环滚动

## 代码添加
	     JKScrollFocus *scroller = [[JKScrollFocus alloc] initWithFrame:CGRectMake(0, 100, 320, 120)];
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
    scroller.autoScroll = YES;
    [scroller didSelectJKScrollFocusItem:^(NSInteger index) {
        NSLog(@"click %ld",index);
    }];
    [scroller downloadJKScrollFocusItem:^(id item, UIImageView *currentImageView) {
        //这里我使用SDWebImage进行加载网络图片,可以使用自己的方法
        News *n = item;
        [currentImageView sd_setImageWithURL:[NSURL URLWithString:n.imageURL] placeholderImage:nil];
    }];
    [scroller titleForJKScrollFocusItem:^NSString *(id item, UILabel *currentLabel) {
        News *n = item;
        return n.title;
    }];
    [self.view addSubview:scroller];
    
## XIB拖拽

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

    self.scrollerFocus.items = secondArray;
    self.scrollerFocus.autoScroll = YES;
    [self.scrollerFocus didSelectJKScrollFocusItem:^(NSInteger index) {
        NSLog(@"click %ld",index);
    }];
    [self.scrollerFocus titleForJKScrollFocusItem:^NSString *(id item, UILabel *currentLabel) {
        News *n = item;
        return n.title;
    }];
    [self.scrollerFocus downloadJKScrollFocusItem:^(id item, UIImageView *currentImageView) {
        News *n = item;
        currentImageView.image = [UIImage imageNamed:n.imageURL];
    }];




![image](https://raw.githubusercontent.com/shaojiankui/JKScrollFocus/master/thumb.png)