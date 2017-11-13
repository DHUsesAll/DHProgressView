//
//  DHHighlightProgressView.m
//  Progress
//
//  Created by sxf on 2017/11/13.
//  Copyright © 2017年 sxf. All rights reserved.
//

#import "DHHighlightProgressView.h"

@interface DHHighlightProgressView ()

@property (nonatomic, strong) CAGradientLayer * gradientLayer;
@property (nonatomic, strong) CALayer * maskLayer;

@end

@implementation DHHighlightProgressView

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor highlightColor:(UIColor *)highlightColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _highlightColor = highlightColor;
        self.backgroundColor = backgroundColor;
        [self.layer addSublayer:self.gradientLayer];
        self.layer.mask = self.maskLayer;
    }
    return self;
}

- (void)beginHighlightAnimation
{
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"locations";
    animation.duration = 1.5;
    animation.fromValue = @[@-1,@-0.5,@0,@0.5,@1];
    animation.toValue = @[@0,@0.5,@1,@1.5,@2];
    animation.repeatCount = CGFLOAT_MAX;
    [self.gradientLayer addAnimation:animation forKey:nil];
}

- (void)setProgress:(double)progress animated:(bool)flag
{
    _progress = progress;
    if (_progress > 1) {
        _progress = 1;
    }
    self.maskLayer.frame = CGRectMake(0, 0, self.frame.size.width * _progress, self.maskLayer.frame.size.height);
    if (flag) {
        CABasicAnimation * boundsAnimation = [CABasicAnimation animation];
        boundsAnimation.keyPath = @"bounds";
        boundsAnimation.duration = 1.5;
        // 长度从0开始
        boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, self.maskLayer.frame.size.height)];
        // 根据modelLayer和presentationLayer的关系，我们不设置toValue则系统会自动把modelLayer的值作为toValue
        [self.maskLayer addAnimation:boundsAnimation forKey:nil];
        
        CABasicAnimation * positionAnimation = [CABasicAnimation animation];
        positionAnimation.keyPath = @"position";
        positionAnimation.duration = 1.5;
        positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, self.maskLayer.frame.size.height/2)];
        [self.maskLayer addAnimation:positionAnimation forKey:nil];
    }
}

#pragma mark - setter
- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setHighlightColor:(UIColor *)highlightColor
{
    _highlightColor = highlightColor;
    self.gradientLayer.colors = @[(__bridge id)self.backgroundColor.CGColor,(__bridge id)self.highlightColor.CGColor,(__bridge id)self.backgroundColor.CGColor,(__bridge id)self.highlightColor.CGColor,(__bridge id)self.backgroundColor.CGColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.gradientLayer.colors = @[(__bridge id)self.backgroundColor.CGColor,(__bridge id)self.highlightColor.CGColor,(__bridge id)self.backgroundColor.CGColor,(__bridge id)self.highlightColor.CGColor,(__bridge id)self.backgroundColor.CGColor];
}

#pragma mark - getter
- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        if (!self.backgroundColor || !self.highlightColor) {
            return nil;
        }
        _gradientLayer = ({
            CAGradientLayer * layer = [CAGradientLayer layer];
            layer.frame = self.bounds;
            layer.colors = @[(__bridge id)self.backgroundColor.CGColor,(__bridge id)self.highlightColor.CGColor,(__bridge id)self.backgroundColor.CGColor,(__bridge id)self.highlightColor.CGColor,(__bridge id)self.backgroundColor.CGColor];
            layer.startPoint = CGPointMake(0, 0);
            layer.endPoint = CGPointMake(1, 0);
            layer.locations = @[@-1,@-0.5,@0,@0.5,@1];
            layer;
        });
    }
    return _gradientLayer;
}

- (CALayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = ({
            CALayer * layer = [CALayer layer];
            layer.frame = self.bounds;
            layer.backgroundColor = [UIColor redColor].CGColor;
            layer;
        });
    }
    return _maskLayer;
}

@end
