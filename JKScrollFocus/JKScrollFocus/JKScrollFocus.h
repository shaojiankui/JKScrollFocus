//
//  JKScrollFocus.h
//  JKScrollFocus
//
//  Created by jakey on 14-3-24.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectJKScrollFocusItem)(id item,NSInteger index);
typedef void (^DownloadJKScrollFocusItem)(id item,UIImageView *currentImageView);
typedef NSString * (^TitleForJKScrollFocusItem)(id item,UILabel *currentLabel);

@interface JKScrollFocus : UIView<UIScrollViewDelegate> {
    DidSelectJKScrollFocusItem _didSelectJKScrollFocusItem;
    DownloadJKScrollFocusItem _downloadJKScrollFocusItem;
    TitleForJKScrollFocusItem _titleForJKScrollFocusItem;
    NSInteger _currentPageIndex;
}
/**
 *  @author Jakey, 16-06-02 18:06:48
 *
 *  数据源
 */
@property (nonatomic, strong)NSArray *items;
/**
 *  @author Jakey, 16-06-02 18:06:55
 *
 *  自动轮播
 */
@property (nonatomic, assign) BOOL autoScroll;
/**
 *  @author Jakey, 16-06-02 18:06:17
 *
 *  点击回调
 *
 */
-(void)didSelectJKScrollFocusItem:(DidSelectJKScrollFocusItem)didSelectJKScrollFocusItem;
/**
 *  @author Jakey, 16-06-02 18:06:17
 *
 *  下载/加载对应图片的回调
 *
 */
-(void)downloadJKScrollFocusItem:(DownloadJKScrollFocusItem)downloadJKScrollFocusItem;
/**
 *  @author Jakey, 16-06-02 18:06:39
 *
 *  标题回调
 *
 */
-(void)titleForJKScrollFocusItem:(TitleForJKScrollFocusItem)titleForJKScrollFocusItem;

@end
