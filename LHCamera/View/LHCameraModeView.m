//
//  LHCameraModeView.m
//  LHCamera
//
//  Created by 刘刘欢 on 16/12/8.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

#import "LHCameraModeView.h"
#import "UIView+LHAdditions.h"

#import <CoreText/CoreText.h>

#define COMPONENT_MARGIN 20.0f
#define BUTTON_SIZE CGSizeMake(68.0f,68.0f)

@interface LHCameraModeView()

@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) CATextLayer *videoTextLayer;
@property (nonatomic, strong) CATextLayer *photoTextLayer;
@property (nonatomic, strong) UIView *labelContainerView;

@property (nonatomic, assign) BOOL maxLeft;
@property (nonatomic, assign) BOOL maxRight;
@property (nonatomic, assign) CGFloat videoStringWidth;

@end

@implementation LHCameraModeView


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
    _maxRight = YES;
    //默认为拍摄视频
    self.cameraMode = LHCameraModeVideo;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //拍照的背景色
    _foregroundColor = [UIColor colorWithRed:1.000 green:0.734 blue:0.006 alpha:1.000];
    _videoTextLayer = [self textLayerWithTitle:@"视频"];
    _videoTextLayer.foregroundColor = self.foregroundColor.CGColor;
    _photoTextLayer = [self textLayerWithTitle:@"拍照"];
    
    CGSize size = [@"视频" sizeWithAttributes:[self fontAttributes]];
    self.videoStringWidth = size.width;
    _videoTextLayer.frame = CGRectMake(0.0f, 0.0f, 40.0f, 20.0f);
    _photoTextLayer.frame = CGRectMake(60.0f, 0.0f, 50.0f, 20.0f);
    CGRect containerRect = CGRectMake(0.0f, 0.0f, 120.0f, 20.0f);
    _labelContainerView = [[UIView alloc]initWithFrame:containerRect];
    _labelContainerView.backgroundColor = [UIColor clearColor];
    
    [_labelContainerView.layer addSublayer:_videoTextLayer];
    [_labelContainerView.layer addSublayer:_photoTextLayer];
    _labelContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_labelContainerView];
    
    self.labelContainerView.centerY += 8.0f;
    //右滑手势
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(switchModel:)];
    //左滑手势
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(switchModel:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:rightRecognizer];
    [self addGestureRecognizer:leftRecognizer];
    
    //拍摄按钮
    LHCaptureButton *captureButton = [LHCaptureButton captureButton];
    captureButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 68) / 2, 34, 68, 68);
    [self addSubview:captureButton];
    _captureButton = captureButton;
    
    //缩略图按钮
    UIButton *thumbnailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thumbnailButton.frame = CGRectMake(40, 45, 45, 45);
    thumbnailButton.adjustsImageWhenHighlighted = NO;
    [self addSubview:thumbnailButton];
    _thumbnailButton = thumbnailButton;
}

- (void)switchModel:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft && !self.maxLeft) {
        [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.labelContainerView.frameX -= 62;
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
                [CATransaction disableActions];
                self.photoTextLayer.foregroundColor = self.foregroundColor.CGColor;
                self.videoTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
            } completion:^(BOOL finished) {
                
            }];
        } completion:^(BOOL finished) {
            self.cameraMode = LHCameraModePhoto;
            self.maxLeft = YES;
            self.maxRight = NO;
        }];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight && !self.maxRight) {
        [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.labelContainerView.frameX += 62;
            self.videoTextLayer.foregroundColor = self.foregroundColor.CGColor;
            self.photoTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
        } completion:^(BOOL finished) {
            self.cameraMode = LHCameraModeVideo;
            self.maxRight = YES;
            self.maxLeft = NO;
        }];
    }
}

- (CATextLayer *)textLayerWithTitle:(NSString *)title
{
    CATextLayer *layer = [CATextLayer layer];
    layer.string = [[NSAttributedString alloc]initWithString:title attributes:[self fontAttributes]];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

- (NSDictionary *)fontAttributes
{
    return @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:17.0f],
             NSForegroundColorAttributeName : [UIColor whiteColor]};
}


- (void)setCameraMode:(LHCameraMode)cameraMode
{
    if (_cameraMode != cameraMode) {
        _cameraMode = cameraMode;
        if (cameraMode == LHCameraModePhoto) {
            self.captureButton.selected = NO;
            self.captureButton.captureButtonMode = LHCaptureButtonModePhoto;
            self.layer.backgroundColor = [UIColor blackColor].CGColor;
        } else {
            self.captureButton.captureButtonMode = LHCaptureButtonModeVideo;
            self.layer.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f].CGColor;
        }
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    
    CGRect circleRect = CGRectMake(CGRectGetMidX(rect)-4.0f,2.0f, 6.0f, 6.0f);
    CGContextFillEllipseInRect(context, circleRect);
}

- (void)layoutSubviews
{
    [super layoutSubviews ];
    self.labelContainerView.frameX = CGRectGetMidX(self.bounds) - (self.videoStringWidth / 2.0);
}
@end
