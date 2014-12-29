//
//  ViewController.m
//  ScrollFocusImage
//
//  Created by jakey on 14-3-24.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import "ViewController.h"
#import "ScrollFocus.h"

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

    ScrollFocus *scroller = [[ScrollFocus alloc] initWithFrame:CGRectMake(0, 20, 320, 120)];
    //imageArray 也可以传入网络图片地址数组,ScrollFocus.m中要设置下载图片的第三方框架 一般都是个category
    scroller.imageArray = @[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg", @"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg"];
    scroller.titleArray = @[@"轮播title0",@"轮播title11",@"轮播title22",@"轮播title33", @"轮播title44",@"轮播title55",@"轮播title66",@"轮播title77"];
    scroller.autoScroll = YES;
    [scroller didSelectScrollFocusItem:^(NSInteger index) {
        NSLog(@"click %ld",index);
    }];
    [self.view addSubview:scroller];

    
    
    self.scrollerFocus.imageArray = @[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg", @"4.jpg"];
    self.scrollerFocus.titleArray = @[@"轮播title0",@"轮播title11",@"轮播title22",@"轮播title33", @"轮播title44"];
    self.scrollerFocus.autoScroll = YES;
    [self.scrollerFocus didSelectScrollFocusItem:^(NSInteger index) {
        NSLog(@"click %ld",index);
    }];

    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)reloadData:(id)sender {
    self.scrollerFocus.imageArray = @[@"5.jpg",@"6.jpg",@"7.jpg"];
    self.scrollerFocus.titleArray  =@[@"轮播title55",@"轮播title66",@"轮播title77"];
}
@end
