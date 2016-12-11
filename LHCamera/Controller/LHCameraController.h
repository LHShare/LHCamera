//
//  LHCameraController.h
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

extern NSString *const LHThumbnailCreatedNotification;

@protocol LHCameraControllerDelegate <NSObject>
//当有错误发生时的处理方法
- (void)deviceConfigurationFailedWithError:(NSError *)error;
- (void)mediaCaptureFailedWithError:(NSError *)error;
- (void)assetLibraryWriteFailedWithError:(NSError *)error;

@end

@interface LHCameraController : NSObject

@property (nonatomic, weak) id<LHCameraControllerDelegate> delegate;
//session
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
//配置和捕捉会话
- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;
//切换摄像头
- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;
//摄像头个数
@property (nonatomic, readonly) NSUInteger cameraCount;
@property (nonatomic, readonly) BOOL cameraHasTorch;
@property (nonatomic, readonly) BOOL cameraHasFlash;
@property (nonatomic, readonly) BOOL cameraSupportsTapToFocus;
@property (nonatomic, readonly) BOOL cameraSupportsTapToExpose;
@property (nonatomic) AVCaptureTorchMode torchMode;
@property (nonatomic) AVCaptureFlashMode flashMode;

//对焦和曝光功能
- (void)focusAtPoint:(CGPoint)point;
- (void)exposeAtPoint:(CGPoint)point;
- (void)resetFocusAndExposureModes;
//捕捉静态图片和视频
- (void)captureStillImage;
//录像功能
- (void)startRecording;
- (void)stopRecording;
- (BOOL)isRecording;
- (CMTime)recordedDuration;

@end
