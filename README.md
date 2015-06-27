ScrollFocusImage
================

ScrollFocusImage,ios 焦点图轮播,UIScrollView图片自动轮播

## 代码添加
self.automaticallyAdjustsScrollViewInsets = NO;


ScrollFocus *scroller = [[ScrollFocus alloc] 

initWithFrame:CGRectMake(0, 20, 320, 120)];


scroller.imageArray = @[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg", @"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg"];

scroller.titleArray = @[@"轮播title0",@"轮播title11",@"轮播title22",@"轮播title33", @"轮播title44",@"轮播title55",@"轮播title66",@"轮播title77"];

scroller.autoScroll = YES;

[scroller didSelectScrollFocusItem:^(NSInteger index) {

    NSLog(@"click %ld",index);        
    
}];

[self.view addSubview:scroller];

    
## XIB拖拽

@property (weak, nonatomic) IBOutlet ScrollFocus *scrollerFocus;

self.automaticallyAdjustsScrollViewInsets = NO;

self.scrollerFocus.imageArray = @[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg", @"4.jpg"];

self.scrollerFocus.titleArray = @[@"轮播title0",@"轮播title11",@"轮播title22",@"轮播title33", @"轮播title44"];

self.scrollerFocus.autoScroll = YES;

[self.scrollerFocus didSelectScrollFocusItem:^(NSInteger index) {
    NSLog(@"click %ld",index);
 
 }];


![image](https://raw.githubusercontent.com/shaojiankui/ScrollFocusImage/master/thumb.png)