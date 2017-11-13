//
//  DHRoundedProgressView.h
//  Progress
//
//  Created by sxf on 2017/11/13.
//  Copyright © 2017年 sxf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHProgress.h"

@interface DHRoundedProgressView : UIView <DHProgress>

@property (nonatomic, assign) CGFloat progress;

// just one color
// radius: the distance from center to a point on the line at the center of progress line, so the frame's width = (radius + progressWidth/2) * 2
- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius progressWidth:(CGFloat)progressWidth progressColor:(UIColor *)progressColor;

// gradient from fromColor to toColor, so the progress begins with fromColor and gradually changes to toColor at the end of progress
- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius progressWidth:(CGFloat)progressWidth fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, strong) UIColor * progressColor;
@property (nonatomic, strong) UIColor * fromColor;
@property (nonatomic, strong) UIColor * toColor;

@end
