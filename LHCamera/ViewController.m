//
//  ViewController.m
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import "ViewController.h"
#import "LHCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import "LHPreviewView.h"
#import "LHOverlayView.h"
#import "LHCameraView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()<LHPreviewViewDelegate>

@property (nonatomic, assign) LHCameraMode cameraMode;
@property (nonatomic,strong) LHCameraController *cameraController;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) LHPreviewView *previewView;
@property (nonatomic, strong) LHOverlayView *overlayView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateThumbnail:) name:LHThumbnailCreatedNotification object:nil];
    
    [self buildUI];
    [self controlsAddTarget];
    //相机类型设置成摄像类型
    self.cameraMode = LHCameraModeVideo;
    self.cameraController = [[LHCameraController alloc]init];
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        [self.previewView setSession:self.cameraController.captureSession];
        self.previewView.delegate = self;
        [self.cameraController startSession];
    } else {
        NSLog(@"Error : %@",[error localizedDescription]);
    }
    self.previewView.tapToExposeEnabled = self.cameraController.cameraSupportsTapToExpose;
    self.previewView.tapToFocusEnabled = self.cameraController.cameraSupportsTapToFocus;
}

#pragma mark 更新缩略图
- (void)updateThumbnail:(NSNotification *)notification
{
    UIImage *image = (UIImage *)notification.object;
    [self.overlayView.modeView.thumbnailButton setBackgroundImage:image forState:UIControlStateNormal];
    self.overlayView.modeView.thumbnailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.overlayView.modeView.thumbnailButton.layer.borderWidth = 1.0f;
}

- (void)buildUI
{
    //添加展示视图
    LHCameraView *cameraView = [[LHCameraView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:cameraView];
    self.previewView = cameraView.previewView;
    self.overlayView = cameraView.controlsView;
    
}

#pragma mark 添加控件操作事件
- (void)controlsAddTarget
{
    //拍摄按钮点击事件
    [self.overlayView.modeView.captureButton addTarget:self action:@selector(captureOrRecord:) forControlEvents:UIControlEventTouchUpInside];
    //底部操作条手势操作
    [self.overlayView.modeView addTarget:self action:@selector(cameraModeChanged:) forControlEvents:UIControlEventValueChanged];
    //底部操作条缩略图按钮
    [self.overlayView.modeView.thumbnailButton addTarget:self action:@selector(showCameraRoll:) forControlEvents:UIControlEventTouchUpInside];
    //摄像头旋转按钮点击事件
    [self.overlayView.statusView.changeButton addTarget:self action:@selector(swapCameras:) forControlEvents:UIControlEventTouchUpInside];
    //闪光灯按钮
    [self.overlayView.statusView.flashControl addTarget:self action:@selector(flashControlChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark 闪光灯按钮点击事件
- (void)flashControlChanged:(id)sender
{
    NSInteger mode = [(LHFlashControl *)sender selectedMode];
    if (self.cameraMode == LHCameraModePhoto) {
        self.cameraController.flashMode = mode;
    } else {
        self.cameraController.torchMode = mode;
    }
}

#pragma mark 摄像头旋转按钮点击事件
- (void)swapCameras:(id)sender
{
    if ([self.cameraController switchCameras]) {
        BOOL hidden = NO;
        if (self.cameraMode == LHCameraModePhoto) {
            hidden = !self.cameraController.cameraHasFlash;
        } else {
            hidden = !self.cameraController.cameraHasTorch;
        }
        self.overlayView.flashControlHidden = hidden;
        self.previewView.tapToFocusEnabled = self.cameraController.cameraSupportsTapToFocus;
        self.previewView.tapToExposeEnabled = self.cameraController.cameraSupportsTapToExpose;
    }
}

#pragma mark 底部操作条缩略图按钮点击事件
- (void)showCameraRoll:(id)sender
{
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark 底部操作条手势操作
- (void)cameraModeChanged:(LHCameraModeView *)sender
{
    self.cameraMode = [sender cameraMode];
}

#pragma mark 拍摄按钮点击事件
- (void)captureOrRecord:(UIButton *)sender
{
    if (self.cameraMode == LHCameraModePhoto) {//拍摄照片
        [self.cameraController captureStillImage];
    } else {//录像
        if (!self.cameraController.isRecording) {
            dispatch_async(dispatch_queue_create("cn.com.qzd.lhcamera", NULL), ^{
                [self.cameraController startRecording];
                [self startTimer];
            });
        } else {
            [self.cameraController stopRecording];
            [self stopTimer];
        }
    }
}

#pragma mark 开始计时
- (void)startTimer
{
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateTimeDisplay) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
#pragma mark 停止计时
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    self.overlayView.statusView.elapsedTimeLabel.text = @"00:00:00";
}
#pragma mark 更新时间展示
- (void)updateTimeDisplay
{
    CMTime duration = self.cameraController.recordedDuration;
    NSUInteger time = (NSUInteger)CMTimeGetSeconds(duration);
    NSUInteger hours = time / 3600;
    NSUInteger minutes = (time / 60) % 60;
    NSUInteger seconds = time % 60;
    
    NSString *format = @"%02i:%02i:%02i";
    NSString *timeString = [NSString stringWithFormat:format,hours,minutes,seconds];
    self.overlayView.statusView.elapsedTimeLabel.text = timeString;
}


#pragma mark ----preview--delegate
#pragma mark 对焦
- (void)tappedToFocusAtPoint:(CGPoint)point
{
    [self.cameraController focusAtPoint:point];
}
#pragma mark 曝光
- (void)tappedToExposeAtPoint:(CGPoint)point
{
    [self.cameraController exposeAtPoint:point];
}
#pragma mark 对焦并且曝光
- (void)tappedToResetFocusAndExposure
{
    [self.cameraController resetFocusAndExposureModes];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
