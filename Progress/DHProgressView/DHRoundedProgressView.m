//
//  DHRoundedProgressView.m
//  Progress
//
//  Created by sxf on 2017/11/13.
//  Copyright © 2017年 sxf. All rights reserved.
//

#import "DHRoundedProgressView.h"

@interface DHRoundedProgressView ()

@property (nonatomic, strong) CAGradientLayer * leftLayer;
@property (nonatomic, strong) CAGradientLayer * rightLayer;

@property (nonatomic, strong) CALayer * bottomLayer;
@property (nonatomic, strong) CALayer * containerLayer;
@property (nonatomic, strong) CAShapeLayer * maskLayer;

- (CGRect)frameWithCenter:(CGPoint)center radius:(CGFloat)radius progressWidth:(CGFloat)progressWidth;
- (void)updateFrame;
- (UIColor *)midColor;

@end

@implementation DHRoundedProgressView

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius progressWidth:(CGFloat)progressWidth progressColor:(UIColor *)progressColor
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.center = center;
        _radius = radius;
        _progressWidth = progressWidth;
        _progressColor = progressColor;
        [self updateFrame];
        [self initializeOneColor];
    }
    return self;
}

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius progressWidth:(CGFloat)progressWidth fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.center = center;
        _radius = radius;
        _progressWidth = progressWidth;
        _fromColor = fromColor;
        _toColor = toColor;
        if (!fromColor || !toColor) {
            return nil;
        }
        [self updateFrame];
        [self initializeGradient];
    }
    return self;
}

#pragma mark - private methods
- (CGRect)frameWithCenter:(CGPoint)center radius:(CGFloat)radius progressWidth:(CGFloat)progressWidth
{
    CGFloat length = radius * 2 + progressWidth;
    CGRect frame = CGRectMake(center.x - length/2, center.y - length/2, length, length);
    return frame;
}

- (void)updateFrame {
    self.frame = [self frameWithCenter:self.center radius:self.radius progressWidth:self.progressWidth];
}

- (void)initializeGradient
{
    [self.containerLayer addSublayer:self.leftLayer];
    [self.containerLayer addSublayer:self.rightLayer];
    [self.containerLayer addSublayer:self.bottomLayer];

    self.containerLayer.mask = self.maskLayer;
}

- (void)initializeOneColor
{
    self.containerLayer.backgroundColor = self.progressColor.CGColor;
    self.containerLayer.mask = self.maskLayer;
}

- (UIColor *)midColor
{
    CGFloat fromColorRGBA[4];
    CGFloat toColorRGBA[4];
    [self getRGBComponents:fromColorRGBA forColor:self.fromColor];
    [self getRGBComponents:toColorRGBA forColor:self.toColor];
    
    // = from + (to - from) * 0.5
    CGFloat midR = (fromColorRGBA[0] + toColorRGBA[0]) / 2;
    CGFloat midG = (fromColorRGBA[1] + toColorRGBA[1]) / 2;
    CGFloat midB = (fromColorRGBA[2] + toColorRGBA[2]) / 2;
    CGFloat midA = (fromColorRGBA[3] + toColorRGBA[3]) / 2;
    
    return [UIColor colorWithRed:midR green:midG blue:midB alpha:midA];
}

// thanks for stackoverflow
- (void)getRGBComponents:(CGFloat [4])components forColor:(UIColor *)color
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 4; component++) {
        components[component] = resultingPixel[component] / 255.f;
    }
}

- (void)setProgress:(double)progress animated:(bool)flag
{
    _progress = progress;
    if (_progress > 1) {
        _progress = 1;
    }
    self.maskLayer.strokeEnd = progress;
    if (flag) {
        CABasicAnimation * animation = [CABasicAnimation animation];
        animation.keyPath = @"strokeEnd";
        animation.duration = 0.8 * progress;
        animation.fromValue = @0;
        [self.maskLayer addAnimation:animation forKey:nil];
    }
}

#pragma mark - setter
- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self updateFrame];
}

- (void)setProgressWidth:(CGFloat)progressWidth
{
    _progressWidth = progressWidth;
    [self updateFrame];
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    self.containerLayer.backgroundColor = progressColor.CGColor;
}

- (void)setFromColor:(UIColor *)fromColor
{
    _fromColor = fromColor;
    self.rightLayer.colors = @[(__bridge id)self.fromColor.CGColor,(__bridge id)[self midColor].CGColor];
}

- (void)setToColor:(UIColor *)toColor
{
    _toColor = toColor;
    self.leftLayer.colors = @[(__bridge id)[self midColor].CGColor,(__bridge id)self.toColor.CGColor];
}

#pragma mark - getter
- (CALayer *)containerLayer
{
    return self.layer;
}

- (CAGradientLayer *)leftLayer
{
    if (!_leftLayer) {
        _leftLayer = ({
            CAGradientLayer * layer = [CAGradientLayer layer];
            layer.colors = @[(__bridge id)self.toColor.CGColor,(__bridge id)[self midColor].CGColor];
            layer.startPoint = CGPointMake(0, 0);
            layer.endPoint = CGPointMake(0, 1);
            layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerLayer.frame)/2, CGRectGetHeight(self.containerLayer.frame)-self.progressWidth);
            layer;
        });
    }
    return _leftLayer;
}

- (CAGradientLayer *)rightLayer
{
    if (!_rightLayer) {
        _rightLayer = ({
            CAGradientLayer * layer = [CAGradientLayer layer];
            layer.colors = @[(__bridge id)self.fromColor.CGColor,(__bridge id)[self midColor].CGColor];
            layer.startPoint = CGPointMake(0, 0);
            layer.endPoint = CGPointMake(0, 1);
            layer.frame = CGRectMake(CGRectGetWidth(self.containerLayer.frame)/2, 0, CGRectGetWidth(self.containerLayer.frame)/2, CGRectGetHeight(self.containerLayer.frame)-self.progressWidth);
            layer;
        });
    }
    return _rightLayer;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = ({
            CALayer * layer = [CALayer layer];
            layer.frame = CGRectMake(0, CGRectGetHeight(self.containerLayer.frame)-self.progressWidth, CGRectGetWidth(self.containerLayer.frame), self.progressWidth);
            layer.backgroundColor = self.midColor.CGColor;
            layer;
        });
    }
    return _bottomLayer;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = ({
            CAShapeLayer * layer = [CAShapeLayer layer];
            
            UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius+self.progressWidth/2, self.radius+self.progressWidth/2) radius:self.radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
            layer.path = path.CGPath;
            layer.lineWidth = self.progressWidth;
            layer.strokeColor = [UIColor blackColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.backgroundColor = [UIColor clearColor].CGColor;
            
            layer.strokeEnd = 0;
            
            layer;
        });
    }
    return _maskLayer;
}



@end
