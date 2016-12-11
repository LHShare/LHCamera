//
//  LHOverlayView.m
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import "LHOverlayView.h"

@implementation LHOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
        self.backgroundColor = [UIColor clearColor];
        [self.modeView addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buildUI
{
    self.backgroundColor = [UIColor blackColor];
    self.flashControlHidden = YES;
    //顶部操作条
    LHStatusView *statusView = [[LHStatusView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 48)];
    [self addSubview:statusView];
    self.statusView = statusView;
    //底部操作条
    LHCameraModeView *modeView = [[LHCameraModeView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 110, [UIScreen mainScreen].bounds.size.width, 110)];
    [self addSubview:modeView];
    self.modeView = modeView;
}


- (void)modeChanged:(LHCameraModeView *)modeView
{
    BOOL photoModeEnabled = modeView.cameraMode == LHCameraModePhoto;
    UIColor *toColor = photoModeEnabled ? [UIColor blackColor] : [UIColor colorWithWhite:0.0f alpha:0.5f];
    CGFloat toOpacity = photoModeEnabled ? 0.0f : 1.0f;
    self.statusView.layer.backgroundColor = toColor.CGColor;
    self.statusView.elapsedTimeLabel.layer.opaque = toOpacity;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self.statusView pointInside:[self convertPoint:point toView:self.statusView] withEvent:event] || [self.modeView pointInside:[self convertPoint:point toView:self.modeView] withEvent:event]) {
        return YES;
    }
    return NO;
}

- (void)setFlashControlHidden:(BOOL)flashControlHidden
{
    if (_flashControlHidden != flashControlHidden) {
        _flashControlHidden = flashControlHidden;
        self.statusView.flashControl.hidden = flashControlHidden;
    }
}

@end
