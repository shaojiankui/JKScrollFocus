//
//  ScrollFocus.m
//  ScrollFocusImage
//
//  Created by jakey on 14-3-24.
//  Copyright (c) 2014年 jakey. All rights reserved.
//
static CGFloat SWITCH_FOCUS_IMAGE_INTERVAL = 5.0; //switch interval time

#import "ScrollFocus.h"

@interface ScrollFocus ()

@end

@implementation ScrollFocus

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buidView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"ScrollFocus.frame%@",NSStringFromCGRect(self.frame));
    [self buidView];
}

-(void)buidView{
    self.userInteractionEnabled = YES;
    self.imageArray = [NSArray array];
    self.titleArray = [NSArray array];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _noteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-33,self.bounds.size.width,33)];
    [_noteView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
    [self addSubview:_noteView];
    
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectZero];
    [_noteView addSubview:_pageControl];

    
    _noteTitle=[[UILabel alloc] initWithFrame:CGRectZero];
    [_noteTitle setBackgroundColor:[UIColor clearColor]];
    [_noteTitle setFont:[UIFont systemFontOfSize:13]];
    [_noteView addSubview:_noteTitle];
    
}
-(void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    if (self.imageArray==nil ||[self.imageArray count]==0) {
        _scrollView.contentSize = CGSizeZero;
        [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        return;
    }
    NSInteger pageCount = [_imageArray count];
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * pageCount, self.frame.size.height);
    
    if ([_scrollView.subviews count]>0) {
        [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _pageControl.currentPage=0;
        [self moveToTargetPosition:0];

    }
    [self.imageArray enumerateObjectsUsingBlock:^(id imgURL, NSUInteger idx, BOOL *stop) {
        
        UIImageView *imgView=[[UIImageView alloc] init];
        if ([imgURL hasPrefix:@"http"]) {
            //网络图片 使用异步图片库 即可
            //[imgView setImageWithURL:[NSURL URLWithString:imgURL]];
        }
        else
        {
            UIImage *img=[UIImage imageNamed:imgURL];
            [imgView setImage:img];
        }
        
        [imgView setFrame:CGRectMake(self.frame.size.width*idx, 0,self.frame.size.width, self.frame.size.height)];
        imgView.tag = idx;
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageItemPressed:)];
        [Tap setNumberOfTapsRequired:1];
        [Tap setNumberOfTouchesRequired:1];
        imgView.userInteractionEnabled=YES;
        [imgView addGestureRecognizer:Tap];
        [_scrollView addSubview:imgView];
    }];
    
    
}
-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    //说明文字title
    if (self.titleArray==nil ||[self.titleArray count]==0) {
        _pageControl.hidden =YES;
        _noteTitle.text = @"";

        return;
    }
    _pageControl.hidden = NO;
    NSInteger pageCount = [self.titleArray count];
    
    float pageControlWidth = (pageCount) * 10.0f + 40.f;
    float pagecontrolHeight = 20.0f;
    
    _pageControl.frame = CGRectMake(self.frame.size.width - pageControlWidth,6, pageControlWidth, pagecontrolHeight);
    _pageControl.numberOfPages = (pageCount);
    
    
    _noteTitle.frame = CGRectMake(5, 6, self.frame.size.width - pageControlWidth - 15, 20);
    _noteTitle.text = self.titleArray[0];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    _currentPageIndex = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    _pageControl.currentPage = _currentPageIndex;
    NSInteger titleIndex= _currentPageIndex;
    if (titleIndex==[self.titleArray count]) {
        titleIndex = 0;
    }
    if (titleIndex<0) {
        titleIndex= [self.titleArray count] - 1;
    }
    if (self.titleArray!=nil && [self.titleArray count]>titleIndex) {
        _noteTitle.text = self.titleArray[titleIndex];

    }
    //NSLog(@"page scroll%d",_currentPageIndex);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
}

-(void)didSelectScrollFocusItem:(DidSelectScrollFocusItem)didSelectScrollFocusItem{
    if(didSelectScrollFocusItem){
        _didSelectScrollFocusItem = [didSelectScrollFocusItem copy];
    }
}
- (void)imageItemPressed:(UITapGestureRecognizer *)sender
{
    NSLog(@"%ld",sender.view.tag);
    if (_didSelectScrollFocusItem) {
       _didSelectScrollFocusItem(sender.view.tag);
    }
}
#pragma mark - ScrollView Next
- (void)moveToTargetPage:(NSInteger)targetPage
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    CGFloat targetX = targetPage * _scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_IMAGE_INTERVAL];
}
- (void)moveToTargetPosition:(CGFloat)targetX
{
    if (targetX >= _scrollView.contentSize.width) {
        targetX = 0.0;
    }
    [UIView animateWithDuration:0.4 animations:^{
        [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO] ;
    } completion:^(BOOL finished) {
        
    }];
    _pageControl.currentPage = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
}
- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX =_scrollView.contentOffset.x + _scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    if (_autoScroll) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_IMAGE_INTERVAL];
    }
}
- (void)setAutoScroll:(BOOL)enable
{
    _autoScroll = enable;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    if (_autoScroll) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_IMAGE_INTERVAL];
    }
}

@end
