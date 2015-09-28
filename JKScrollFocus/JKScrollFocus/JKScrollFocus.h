//
//  JKScrollFocus.h
//  JKScrollFocus
//
//  Created by jakey on 14-3-24.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectScrollFocusItem)(NSInteger index);
typedef void (^DownloadFocusItem)(id downloadItem,UIImageView *currentImageView);

@interface JKScrollFocus : UIView<UIScrollViewDelegate> {
    DidSelectScrollFocusItem _didSelectScrollFocusItem;
    DownloadFocusItem _downloadFocusItem;
    NSInteger _currentPageIndex;
}
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, assign) BOOL autoScroll;

-(void)didSelectScrollFocusItem:(DidSelectScrollFocusItem)didSelectScrollFocusItem;
-(void)downloadFocusItem:(DownloadFocusItem)downloadFocusItem;

@end
