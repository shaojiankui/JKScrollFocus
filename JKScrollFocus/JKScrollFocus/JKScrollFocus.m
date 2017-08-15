//
//  JKScrollFocus.m
//  JKScrollFocus
//
//  Created by jakey on 14-3-24.
//  Copyright (c) 2014年 jakey. All rights reserved.
//
#define  SWITCH_FOCUS_IMAGE_INTERVAL   5.0 //switch interval time

#import "JKScrollFocus.h"
@interface JKScrollFocus ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *threeItems;
@end

@implementation JKScrollFocus

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buidView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self buidView];
}
- (void)buidView{
    self.userInteractionEnabled = YES;

    self.backgroundColor = [UIColor grayColor];
    //_scrollView
    [self insertSubview:self.scrollView atIndex:0];
    self.clipsToBounds = YES;
}
- (void)layoutSubviews{
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _scrollView.contentSize =CGSizeMake(self.frame.size.width*3, self.frame.size.height);
    [self reloadData];
}
#pragma getter method
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (NSMutableArray *)threeItems{
    if(!_threeItems){
        _threeItems  = [NSMutableArray array];
    }
    return _threeItems;
}
#pragma data handle
- (void)setItems:(NSArray *)items{
    _items = items;
    _currentPageIndex = 0;
    [self setNeedsLayout];
    [self moveToPage:_currentPageIndex];
}
- (void)setInterval:(NSTimeInterval)interval{
    _interval = interval;
}
- (void)reloadData{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.items==nil ||[self.items count]==0) {
        _scrollView.contentSize = CGSizeZero;
        return;
    }
    
    if (_didChangeJKScrollFocusItem) {
        _didChangeJKScrollFocusItem([self.items firstObject],0);
    }
    [self.threeItems removeAllObjects];
    [self.threeItems addObject:[self.items objectAtIndex:[self getNextPage:_currentPageIndex-1]]];
    [self.threeItems addObject:[self.items objectAtIndex:_currentPageIndex]];
    [self.threeItems addObject:[self.items objectAtIndex:[self getNextPage:_currentPageIndex+1]]];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, self.frame.size.height);
    for (int i = 0; i < [self.threeItems count]; i++) {
        UIImageView *currentView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)*i, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        currentView.userInteractionEnabled=YES;
        currentView.tag = 1;
        if (_downloadJKScrollFocusItem) {
            _downloadJKScrollFocusItem(_threeItems[i],currentView);
        }
        //currentView.image = [UIImage imageNamed:_threeItems[i]];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageItemPressed:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [currentView addGestureRecognizer:tap];
        [_scrollView addSubview:currentView];
    }
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
}

- (NSInteger)getNextPage:(NSInteger)currentIndex
{
    NSInteger index;
    if (currentIndex==-1) {
        index = self.items.count-1;
    }else if (currentIndex==self.items.count){
        index = 0;
    }else{
        index = currentIndex;
    }
    return index;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int offsetX = scrollView.contentOffset.x;
//    if ((xOffset % (int)CGRectGetWidth(self.bounds) == 0)) {
//        _pageControl.currentPage = _currentPageIndex;
//    }
    if(offsetX >= (2*CGRectGetWidth(self.bounds))) {
        //向右
        _currentPageIndex = [self getNextPage:_currentPageIndex+1];
        [self reloadData];
    }
    if(offsetX <= 0) {
        //向左
        _currentPageIndex = [self getNextPage:_currentPageIndex-1];

        [self reloadData];
    }
    
    [self moveToPage:_currentPageIndex];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_autoSwitch) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0) animated:YES];
}
- (void)moveToPage:(NSInteger)page{
    if (_didChangeJKScrollFocusItem  && [self.items count]>page) {
       _didChangeJKScrollFocusItem([self.items objectAtIndex:page],page);
    }
    if (_autoSwitch) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:(_interval>0)?:SWITCH_FOCUS_IMAGE_INTERVAL];
    }
}
#pragma mark - ScrollView Next
- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    _currentPageIndex++;
    if ([self.items count]>0) {
        _currentPageIndex = _currentPageIndex % [self.items count];
    }
    
    CAAnimation *animation;
    if (_animationForJKScrollFocusSwitch) {
        animation = _animationForJKScrollFocusSwitch(_scrollView,_currentPageIndex);
    }else{
        CATransition *animationT = [CATransition animation];
        [animationT setDuration:0.35f];
        [animationT setFillMode:kCAFillModeForwards];
        [animationT setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [animationT setType:kCATransitionPush];
        [animationT setSubtype:kCATransitionFromRight];
        animation = animationT;
    }
   
    [_scrollView.layer addAnimation:animation forKey:nil];
    
    [self reloadData];
    [self moveToPage:_currentPageIndex];
}
- (void)setAutoSwitch:(BOOL)enable
{
    _autoSwitch = enable;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    if (_autoSwitch) {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_IMAGE_INTERVAL];
    }
}
#pragma mark --block
- (void)didSelectJKScrollFocusItem:(DidSelectJKScrollFocusItem)didSelectJKScrollFocusItem;{
    _didSelectJKScrollFocusItem= [didSelectJKScrollFocusItem copy];
    [self setNeedsLayout];
}
- (void)downloadJKScrollFocusItem:(DownloadJKScrollFocusItem)downloadJKScrollFocusItem{
    _downloadJKScrollFocusItem = [downloadJKScrollFocusItem copy];
    _currentPageIndex = 0;
    [self setNeedsLayout];
}

- (void)didChangeJKScrollFocusItem:(DidChangeJKScrollFocusItem)didChangeJKScrollFocusItem{
    _didChangeJKScrollFocusItem = [didChangeJKScrollFocusItem copy];
    [self setNeedsLayout];
}
- (void)animationForJKScrollFocusSwitch:(AnimationForJKScrollFocusSwitch)animationForJKScrollFocusSwitch{
    _animationForJKScrollFocusSwitch = [animationForJKScrollFocusSwitch copy];
    _currentPageIndex = 0;
    [self setNeedsLayout];
}
#pragma mark --click handle
- (void)imageItemPressed:(UITapGestureRecognizer *)sender
{
//    NSLog(@"%ld",sender.view.tag);
    if (_didSelectJKScrollFocusItem) {
       _didSelectJKScrollFocusItem([self.items objectAtIndex:_currentPageIndex],_currentPageIndex);
    }
}


@end
