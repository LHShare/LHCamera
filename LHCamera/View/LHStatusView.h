//
//  LHStatusView.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

//顶部操作条

#import <UIKit/UIKit.h>
#import "LHFlashControl.h"

@interface LHStatusView : UIView<LHFlashControlDelegate>

@property (nonatomic, strong) LHFlashControl *flashControl;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UILabel *elapsedTimeLabel;

@end
