//
//  ViewController.m
//  ScrollFocusImage
//
//  Created by jakey on 14-3-24.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import "ViewController.h"
#import "JKScrollFocus.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;

    JKScrollFocus *scroller = [[JKScrollFocus alloc] initWithFrame:CGRectMake(0, 100, 320, 120)];
    //imageArray 也可以传入网络图片地址数组
    
    scroller.imageArray = @[@"http://img.ivsky.com/img/tupian/co/201507/27/langshan-002.jpg",
                            @"http://img.ivsky.com/img/tupian/co/201507/28/zise_de_jiegenghua-002.jpg",
                            @"http://img.ivsky.com/img/tupian/co/201507/28/ziweihua.jpg",
                            @"http://img.ivsky.com/img/bizhi/co/201508/23/sinbawa-002.jpg",
                            @"http://img.ivsky.com/img/bizhi/co/201508/25/call_of_duty_online-001.jpg",
                            @"http://img.ivsky.com/img/bizhi/co/201508/25/beginning_of_autumn-004.jpg",
                            @"http://img.ivsky.com/img/bizhi/co/201509/24/yazuishou_boy-001.jpg",
                            @"http://img.ivsky.com/img/tupian/co/201507/28/santo_wine-009.jpg"];
    scroller.titleArray = @[@"轮播title0",@"轮播title11",@"轮播title22",@"轮播title33", @"轮播title44",@"轮播title55",@"轮播title66",@"轮播title77"];
    scroller.autoScroll = YES;
    [scroller didSelectScrollFocusItem:^(NSInteger index) {
        NSLog(@"click %ld",index);
    }];
    [scroller downloadFocusItem:^(id downloadItem, UIImageView *currentImageView) {
        //这里我使用SDWebImage进行加载网络图片,可以使用自己的方法
        [currentImageView sd_setImageWithURL:[NSURL URLWithString:downloadItem] placeholderImage:nil];
    }];
    [self.view addSubview:scroller];

    
    
    self.scrollerFocus.imageArray =  @[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg", @"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg"];
    self.scrollerFocus.titleArray = @[@"轮播title0",@"轮播title11",@"轮播title22",@"轮播title33", @"轮播title44",@"轮播title55",@"轮播title66",@"轮播title77"];
    self.scrollerFocus.autoScroll = YES;
    [self.scrollerFocus didSelectScrollFocusItem:^(NSInteger index) {
        NSLog(@"click %ld",index);
    }];
    [self.scrollerFocus downloadFocusItem:^(id item, UIImageView *currentImageView) {
        currentImageView.image = [UIImage imageNamed:item];
    }];

    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)reloadData:(id)sender {
    self.scrollerFocus.imageArray = @[@"5.jpg",@"6.jpg",@"7.jpg"];
    self.scrollerFocus.titleArray  =@[@"轮播title55",@"轮播title66",@"轮播title77"];
}
@end
