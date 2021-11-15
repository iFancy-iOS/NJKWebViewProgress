//
//  NJKWebViewProgressView.m
//
//  Created by Satoshi Aasanoon 11/16/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import "NJKWebViewProgressView.h"

@implementation NJKWebViewProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureViews];
}

-(void)configureViews
{
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:self.bounds];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    /*
    UIColor *tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0]; // iOS7 Safari bar color
    if ([UIApplication.sharedApplication.delegate.window respondsToSelector:@selector(setTintColor:)] && UIApplication.sharedApplication.delegate.window.tintColor) {
        tintColor = UIApplication.sharedApplication.delegate.window.tintColor;
    }
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
     
     _barAnimationDuration = 0.27f;
     _fadeAnimationDuration = 0.27f;
     _fadeOutDelay = 0.1f;
     */
    
    _progressBarView.clipsToBounds = YES;
    [self addSubview:_progressBarView];
    
    _progressView = [[UIView alloc] initWithFrame:_progressBarView.bounds];
    [self addLayerWithFrame:CGRectMake(0, 0, _progressView.frame.size.width, _progressView.frame.size.height)
                       view:_progressView
                 beginColor:[UIColor colorWithRed:255.f / 255.f green:211.f / 255.f blue:33.f / 255.f alpha:0.f]
                   endColor:[UIColor colorWithRed:255.f / 255.f green:211.f / 255.f blue:33.f / 255.f alpha:1.f]
                  locations:@[@(0.05),@(1.0)]
                     isDown:NO];
    [_progressBarView addSubview:_progressView];
    
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

-(void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        self.progressBarView.frame = frame;
    } completion:nil];

    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = self.progressBarView.frame;
            frame.size.width = 0;
            self.progressBarView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

- (void)addLayerWithFrame:(CGRect)frame
                    view:(UIView *)view
              beginColor:(UIColor *)beginColor
                endColor:(UIColor *)endColor
               locations:(NSArray<NSNumber *> *)locations
                  isDown:(BOOL)isDown {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)beginColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = locations;
    gradientLayer.startPoint = CGPointMake(0, 0);
    if (isDown) {
        gradientLayer.endPoint = CGPointMake(0, 1.0);
    } else {
        gradientLayer.endPoint = CGPointMake(1.0, 0);
    }
    gradientLayer.frame = frame;
    [view.layer addSublayer:gradientLayer];
}

@end

