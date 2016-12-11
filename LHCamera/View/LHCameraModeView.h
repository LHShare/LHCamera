//
//  LHCameraModeView.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

//底部操作条

#import <UIKit/UIKit.h>
#import "LHCaptureButton.h"

typedef NS_ENUM(NSUInteger, LHCameraMode) {
    LHCameraModePhoto = 0,
    LHCameraModeVideo = 1
};

@interface LHCameraModeView : UIControl

@property (nonatomic, assign) LHCameraMode cameraMode;
//按钮
@property (nonatomic, strong) LHCaptureButton *captureButton;
//缩略图按钮
@property (nonatomic, strong) UIButton *thumbnailButton;

@end
