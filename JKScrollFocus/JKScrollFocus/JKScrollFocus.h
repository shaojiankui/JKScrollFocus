//
//  JKScrollFocus.h
//  JKScrollFocus
//
//  Created by jakey on 14-3-24.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef void (^DidSelectJKScrollFocusItem)(id item,NSInteger index);
typedef void (^DownloadJKScrollFocusItem)(id item,UIImageView *currentImageView);
typedef void (^DidChangeJKScrollFocusItem)(id item,NSInteger index);

typedef CAAnimation * (^AnimationForJKScrollFocusSwitch)(UIScrollView *scrollView,NSInteger index);

@interface JKScrollFocus : UIView<UIScrollViewDelegate> {
    DidSelectJKScrollFocusItem _didSelectJKScrollFocusItem;
    DownloadJKScrollFocusItem _downloadJKScrollFocusItem;
    DidChangeJKScrollFocusItem _didChangeJKScrollFocusItem;
    AnimationForJKScrollFocusSwitch _animationForJKScrollFocusSwitch;
    NSInteger _currentPageIndex;
}
/**
 *
 *  数据源
 */
@property (nonatomic, strong) NSArray *items;
/**
 *
 *  自动轮播切换
 */
@property (nonatomic, assign) BOOL autoSwitch;
/**
 *
 *  切换时间间隔 默认五秒
 */
@property (nonatomic, assign) NSTimeInterval interval;

/**
 *
 *  点击回调
 *
 */
- (void)didSelectJKScrollFocusItem:(DidSelectJKScrollFocusItem)didSelectJKScrollFocusItem;
/**
 *
 *  下载/加载对应图片的回调
 *
 */
- (void)downloadJKScrollFocusItem:(DownloadJKScrollFocusItem)downloadJKScrollFocusItem;
/**
 *
 *  当前数据改变回调
 *
 */
- (void)didChangeJKScrollFocusItem:(DidChangeJKScrollFocusItem)didChangeJKScrollFocusItem;
/**
 *
 *  自定义切换动画
 *
 */
- (void)animationForJKScrollFocusSwitch:(AnimationForJKScrollFocusSwitch)animationForJKScrollFocusSwitch;

@end
