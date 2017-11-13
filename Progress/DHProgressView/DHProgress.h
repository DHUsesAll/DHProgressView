//
//  DHProgress.h
//  Progress
//
//  Created by sxf on 2017/11/13.
//  Copyright © 2017年 sxf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DHProgress <NSObject>

@required
@property (nonatomic) double progress;

@optional
- (void)setProgress:(double)progress animated:(bool)flag;

@end
