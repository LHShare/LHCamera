//
//  LHStatusView.m
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import "LHStatusView.h"

@interface LHStatusView()<LHFlashControlDelegate>

@end

@implementation LHStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.flashControl.delegate = self;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //闪光灯控件
    LHFlashControl *flashControl = [[LHFlashControl alloc]initWithFrame:CGRectMake(16, 0, 48, 48)];
    flashControl.delegate = self;
    [self addSubview:flashControl];
    self.flashControl = flashControl;
    //timelabel
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake((self.frame.size.width - 82) / 2, 11, 82, 26);
    timeLabel.text = @"00:00:00";
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:19];
    [self addSubview:timeLabel];
    self.elapsedTimeLabel = timeLabel;
    //切换按钮
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    changeButton.frame = CGRectMake(self.frame.size.width - 56, 0, 56, 48);
    [self addSubview:changeButton];
    self.changeButton = changeButton;
}

- (void)flashControlWillExpand
{
    [UIView animateWithDuration:0.2f animations:^{
        self.elapsedTimeLabel.alpha = 0.0f;
    }];
}

- (void)flashControlDidCollapse
{
    [UIView animateWithDuration:0.1f animations:^{
        self.elapsedTimeLabel.alpha = 1.0f;
    }];
}


@end
