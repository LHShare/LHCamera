//
//  LHOverlayView.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

//操作视图

#import <UIKit/UIKit.h>
#import "LHCameraModeView.h"
#import "LHStatusView.h"


@interface LHOverlayView : UIView
//底部操作条
@property (nonatomic, strong) LHCameraModeView *modeView;
//顶部操作条
@property (nonatomic, strong) LHStatusView *statusView;
//闪光灯控件隐藏
@property (nonatomic, assign) BOOL flashControlHidden;

@end
