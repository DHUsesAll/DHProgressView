//
//  DHHighlightProgressView.h
//  Progress
//
//  Created by sxf on 2017/11/13.
//  Copyright © 2017年 sxf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHProgress.h"

@interface DHHighlightProgressView : UIView <DHProgress>

@property (nonatomic, assign) CGFloat progress;

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor highlightColor:(UIColor *)highlightColor;

- (void)beginHighlightAnimation;

@property (nonatomic, strong) UIColor * highlightColor;

@end
