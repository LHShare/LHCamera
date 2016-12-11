//
//  LHCameraView.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

//装载所有视图的容器

#import <UIKit/UIKit.h>
#import "LHPreviewView.h"
#import "LHOverlayView.h"

@interface LHCameraView : UIView

@property (nonatomic, strong) LHPreviewView *previewView;
@property (nonatomic, strong) LHOverlayView *controlsView;

@end
