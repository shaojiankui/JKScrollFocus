//
//  ViewController.h
//  ScrollFocusImage
//
//  Created by jakey on 14-3-24.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollFocus.h"

@interface ViewController : UIViewController
- (IBAction)reloadData:(id)sender;

@property (weak, nonatomic) IBOutlet ScrollFocus *scrollerFocus;

@end
