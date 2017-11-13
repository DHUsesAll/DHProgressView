//
//  ViewController.m
//  Progress
//
//  Created by sxf on 2017/11/7.
//  Copyright © 2017年 sxf. All rights reserved.
//

#import "ViewController.h"
#import "DHRoundedProgressView.h"
#import "DHHighlightProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DHRoundedProgressView * progressView = [[DHRoundedProgressView alloc] initWithCenter:self.view.center radius:150 progressWidth:20 fromColor:[UIColor blueColor] toColor:[UIColor greenColor]];
    [progressView setProgress:0.8 animated:YES];
    [self.view addSubview:progressView];

    DHHighlightProgressView * highlightView = [[DHHighlightProgressView alloc] initWithFrame:CGRectMake(0, 0, 250, 30) backgroundColor:[UIColor purpleColor] highlightColor:[UIColor yellowColor]];
    [highlightView beginHighlightAnimation];
    [highlightView setProgress:1 animated:YES];
    highlightView.center = self.view.center;
    [self.view addSubview:highlightView];
}

@end
