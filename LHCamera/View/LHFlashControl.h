//
//  LHFlashControl.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

//闪光灯控制控件

#import <UIKit/UIKit.h>

@class LHFlashControl;

@protocol LHFlashControlDelegate <NSObject>

@optional
- (void)flashControlWillExpand;
- (void)flashControlDidExpand;
- (void)flashControlWillCollapse;
- (void)flashControlDidCollapse;

@end

@interface LHFlashControl : UIControl

@property (nonatomic, assign) NSInteger selectedMode;
@property (nonatomic, weak) id<LHFlashControlDelegate> delegate;

@end
