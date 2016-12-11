//
//  LHPreviewView.m
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import "LHPreviewView.h"
#import "NSTimer+Additions.h"

#define BOX_BOUCDS CGRectMake(0.0f, 0.0f, 150.0f, 150.0f)

@interface LHPreviewView()

@property (nonatomic, strong) UIView *focusBox;
@property (nonatomic, strong) UIView *exposureBox;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleDoubleTapRecognezer;

@end

@implementation LHPreviewView

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
    [(AVCaptureVideoPreviewLayer *)self.layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    _singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    _doubleTapRecognizer.numberOfTapsRequired = 2;
    _doubleDoubleTapRecognezer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleDoubleTap:)];
    _doubleDoubleTapRecognezer.numberOfTapsRequired = 2;
    _doubleDoubleTapRecognezer.numberOfTouchesRequired = 2;
    
    [self addGestureRecognizer:_singleTapRecognizer];
    [self addGestureRecognizer:_doubleTapRecognizer];
    [self addGestureRecognizer:_doubleDoubleTapRecognezer];
    [_singleTapRecognizer requireGestureRecognizerToFail:_doubleTapRecognizer];
    
    _focusBox = [self viewWithColor:[UIColor colorWithRed:0.102 green:0.636 blue:1.000 alpha:1.000]];
    _exposureBox = [self viewWithColor:[UIColor colorWithRed:1.000 green:0.421 blue:0.054 alpha:1.000]];
    [self addSubview:_focusBox];
    [self addSubview:_exposureBox];
}

#pragma mark 单击手势
- (void)handleSingleTap:(UIGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    [self runBoxAnimationOnView:self.focusBox point:point];
    if (self.delegate) {
        [self.delegate tappedToFocusAtPoint:[self captureDevicePointForPoint:point]];
    }
}

#pragma mark 双击手势
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    [self runBoxAnimationOnView:self.exposureBox point:point];
    if (self.delegate) {
        [self.delegate tappedToExposeAtPoint:[self captureDevicePointForPoint:point]];
    }
}

#pragma mark 两个触点双击收拾
- (void)handleDoubleDoubleTap:(UIGestureRecognizer *)recognizer
{
    [self runResetAnimation];
    if (self.delegate) {
        [self.delegate tappedToResetFocusAndExposure];
    }
}

#pragma mark 坐标转换，将屏幕坐标点转为摄像头坐标点
- (CGPoint)captureDevicePointForPoint:(CGPoint)point
{
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    return [layer captureDevicePointOfInterestForPoint:point];
}

#pragma mark 点击屏幕显示盒子
- (void)runBoxAnimationOnView:(UIView *)view point:(CGPoint)point
{
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    } completion:^(BOOL finished) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            view.hidden = YES;
            view.transform = CGAffineTransformIdentity;
        });
    }];
}

#pragma mark 显示两个盒子
- (void)runResetAnimation
{
    if (!self.tapToExposeEnabled && !self.tapToFocusEnabled) {
        return;
    }
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    CGPoint centerPoint = [previewLayer pointForCaptureDevicePointOfInterest:CGPointMake(0.5f, 0.5f)];
    self.focusBox.center = centerPoint;
    self.exposureBox.center = centerPoint;
    self.exposureBox.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    self.focusBox.hidden = NO;
    self.exposureBox.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.focusBox.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        self.exposureBox.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1.0);
    } completion:^(BOOL finished) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            self.focusBox.hidden = YES;
            self.exposureBox.hidden = YES;
            self.focusBox.transform = CGAffineTransformIdentity;
            self.exposureBox.transform = CGAffineTransformIdentity;
        });
    }];
}

#pragma mark 允许对焦
- (void)setTapToFocusEnabled:(BOOL)tapToFocusEnabled
{
    _tapToFocusEnabled = tapToFocusEnabled;
    self.singleTapRecognizer.enabled = tapToFocusEnabled;
}


#pragma mark 允许曝光
- (void)setTapToExposeEnabled:(BOOL)tapToExposeEnabled
{
    _tapToExposeEnabled = tapToExposeEnabled;
    self.doubleTapRecognizer.enabled = tapToExposeEnabled;
}


#pragma mark 创建盒子
- (UIView *)viewWithColor:(UIColor *)color
{
    UIView *view = [[UIView alloc]initWithFrame:BOX_BOUCDS];
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 5.0f;
    view.hidden = YES;
    return view;
}


+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    return [(AVCaptureVideoPreviewLayer *) self.layer session];
}

- (void)setSession:(AVCaptureSession *)session
{
    [(AVCaptureVideoPreviewLayer *)self.layer setSession:session];
}


@end
