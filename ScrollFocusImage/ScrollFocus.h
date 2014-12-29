//
//  ScrollFocus.h
//  ScrollFocusImage
//
//  Created by jakey on 14-3-24.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectScrollFocusItem)(NSInteger index);

@interface ScrollFocus : UIView<UIScrollViewDelegate> {
	UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    UILabel *_noteTitle;
    UIView *_noteView;
    DidSelectScrollFocusItem _didSelectScrollFocusItem;

    int _currentPageIndex;

}
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, assign) BOOL autoScroll;
-(void)didSelectScrollFocusItem:(DidSelectScrollFocusItem)didSelectScrollFocusItem;
@end
