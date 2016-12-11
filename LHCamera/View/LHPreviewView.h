//
//  LHPreviewView.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

//拍摄视图

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol LHPreviewViewDelegate <NSObject>
//点击对焦
- (void)tappedToFocusAtPoint:(CGPoint)point;
//点击曝光
- (void)tappedToExposeAtPoint:(CGPoint)point;
//点击对焦曝光
- (void)tappedToResetFocusAndExposure;


@end

@interface LHPreviewView : UIView

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) id<LHPreviewViewDelegate> delegate;
//是否可以对焦
@property (nonatomic, assign) BOOL tapToFocusEnabled;
//是否可以曝光
@property (nonatomic, assign) BOOL tapToExposeEnabled;

@end
