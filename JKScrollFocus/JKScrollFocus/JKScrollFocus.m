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
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)UILabel *noteTitle;
@property (nonatomic, strong)UIView *noteView;
@property (nonatomic, strong)NSMutableArray *threeItems;
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

-(void)awakeFromNib{
    [super awakeFromNib];
    [self buidView];
}
-(void)buidView{
    self.userInteractionEnabled = YES;
    self.imageArray = [NSArray array];
    self.titleArray = [NSArray array];
    self.backgroundColor = [UIColor grayColor];
    //_scrollView
    [self addSubview:self.scrollView];
    //_noteView
    [self addSubview:self.noteView];
    //_pageControl
    [_noteView addSubview:self.pageControl];
    //_noteTitle
    [_noteView addSubview:self.noteTitle];
    self.clipsToBounds = YES;
    
}
-(void)layoutSubviews{
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _noteView.frame =CGRectMake(0, self.bounds.size.height-33,self.bounds.size.width,33);
    _scrollView.contentSize =CGSizeMake(self.frame.size.width*3, self.frame.size.height);
    
    float pageControlWidth = ([self.imageArray count]) * 10.0f + 60.f;
    float pagecontrolHeight = 20.0f;
    _pageControl.frame = CGRectMake(self.frame.size.width - pageControlWidth, 6, pageControlWidth, pagecontrolHeight);
     _noteTitle.frame = CGRectMake(5, 6, self.frame.size.width - pageControlWidth - 15, 20);

    [self reloadData];
}
#pragma getter method
-(UIScrollView *)scrollView{
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
-(UIView *)noteView{
    if (!_noteView) {
        _noteView = [[UIView alloc] initWithFrame:CGRectZero];
        [_noteView setBackgroundColor:[UIColor blackColor]];
    }
    return _noteView;
}
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectZero];
    }
    return _pageControl;
}
-(UILabel *)noteTitle{
    if (!_noteTitle) {
        _noteTitle=[[UILabel alloc] initWithFrame:CGRectZero];
        [_noteTitle setBackgroundColor:[UIColor clearColor]];
        _noteTitle.textColor = [UIColor whiteColor];
        [_noteTitle setFont:[UIFont systemFontOfSize:13]];
    }
    return _noteTitle;
}
-(NSMutableArray *)threeItems{
    if(!_threeItems){
        _threeItems  = [NSMutableArray array];
    }
    return _threeItems;
}
#pragma data handle
-(void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    _currentPageIndex = 0;
    [self setNeedsDisplay];
    [self reloadData];
}
-(void)reloadData{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.imageArray==nil ||[self.imageArray count]==0) {
        _scrollView.contentSize = CGSizeZero;
        return;
    }
  
    [self.threeItems removeAllObjects];
    [self.threeItems addObject:[self.imageArray objectAtIndex:[self getNextPage:_currentPageIndex-1]]];
    [self.threeItems addObject:[self.imageArray objectAtIndex:_currentPageIndex]];
    [self.threeItems addObject:[self.imageArray objectAtIndex:[self getNextPage:_currentPageIndex+1]]];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, self.frame.size.height);
    for (int i = 0; i < [self.threeItems count]; i++) {
        UIImageView *currentView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)*i, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        currentView.userInteractionEnabled=YES;
        currentView.tag = 1;
        if (_downloadFocusItem) {
            _downloadFocusItem(_threeItems[i],currentView);
        }
//        currentView.image = [UIImage imageNamed:_threeItems[i]];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageItemPressed:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [currentView addGestureRecognizer:tap];
        [_scrollView addSubview:currentView];
    }
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
}

-(NSInteger)getNextPage:(NSInteger)currentIndex
{
    NSInteger index;
    if (currentIndex==-1) {
        index = self.imageArray.count-1;
    }else if (currentIndex==self.imageArray.count){
        index = 0;
    }else{
        index = currentIndex;
    }
    return index;
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    if (self.titleArray==nil ||[self.titleArray count]==0) {
        _pageControl.hidden =YES;
        _noteTitle.text = @"";
        return;
    }
    
    _pageControl.hidden = NO;
    NSInteger pageCount = [self.titleArray count];
    _pageControl.numberOfPages = (pageCount);
    _noteTitle.text = [self.titleArray firstObject];
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
    
    if (self.titleArray!=nil && [self.titleArray count]>_currentPageIndex) {
        _noteTitle.text = self.titleArray[_currentPageIndex];
    }
    _pageControl.currentPage = _currentPageIndex;

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_autoScroll) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0) animated:YES];
}
#pragma mark - ScrollView Next

- (void)switchFocusImageItems
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    _currentPageIndex++;
    _currentPageIndex = _currentPageIndex % [self.imageArray count];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    
    [_scrollView.layer addAnimation:animation forKey:nil];
    
    [self reloadData];
    _pageControl.currentPage = _currentPageIndex;
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
#pragma mark --block
-(void)didSelectScrollFocusItem:(DidSelectScrollFocusItem)didSelectScrollFocusItem{
    if(didSelectScrollFocusItem){
        _didSelectScrollFocusItem = [didSelectScrollFocusItem copy];
    }
}
-(void)downloadFocusItem:(DownloadFocusItem)downloadFocusItem{
    _downloadFocusItem = [downloadFocusItem copy];
    _currentPageIndex = 0;
    [self setNeedsDisplay];
    [self reloadData];
}
#pragma mark --click handle
- (void)imageItemPressed:(UITapGestureRecognizer *)sender
{
    NSLog(@"%ld",sender.view.tag);
    if (_didSelectScrollFocusItem) {
       _didSelectScrollFocusItem(_currentPageIndex);
    }
}


@end
