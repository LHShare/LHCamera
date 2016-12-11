//
//  LHCaptureButton.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

//拍摄按钮

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LHCaptureButtonMode) {
    LHCaptureButtonModePhoto = 0,
    LHCaptureButtonModeVideo = 1
};

@interface LHCaptureButton : UIButton

+ (instancetype)captureButton;
+ (instancetype)captureButtonWithMode:(LHCaptureButtonMode)captureButtonMode;

@property (nonatomic, assign) LHCaptureButtonMode captureButtonMode;



@end
