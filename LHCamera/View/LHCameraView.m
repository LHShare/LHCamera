//
//  LHCameraView.m
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import "LHCameraView.h"

@implementation LHCameraView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    self.backgroundColor = [UIColor blackColor];
    LHPreviewView *previewView = [[LHPreviewView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self addSubview:previewView];
    self.previewView = previewView;
    LHOverlayView *overlayView = [[LHOverlayView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self addSubview:overlayView];
    self.controlsView = overlayView;
}

@end
