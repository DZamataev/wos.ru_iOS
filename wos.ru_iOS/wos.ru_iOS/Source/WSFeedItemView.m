//
//  WSFeedCell.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSFeedItemView.h"

@implementation WSFeedItemView

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self commonInit];
}

- (void)commonInit
{
    _gradientBgViewLayer = [WSFeedItemView lightHorizontalGradientLayer];
    _gradientBgViewLayer.frame = _gradientBgView.bounds;
    [_gradientBgView.layer insertSublayer:_gradientBgViewLayer atIndex:0];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.bgView.backgroundColor = [UIColor darkGrayColor];
    }
    else {
        self.bgView.backgroundColor = [UIColor clearColor];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.bgView.backgroundColor = [UIColor darkGrayColor];
    }
    else {
        self.bgView.backgroundColor = [UIColor clearColor];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientBgViewLayer.frame = _gradientBgView.bounds;
}

- (void)setLightGradientHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            if (hidden) {
                _gradientBgViewLayer.opacity = 0.0f;
            }
            else {
                _gradientBgViewLayer.opacity = 1.0f;
            }
        } completion:^(BOOL finished) {
            _gradientBgViewLayer.hidden = hidden;
        }];
    }
    else {
        _gradientBgViewLayer.hidden = hidden;
    }
}

+ (CAGradientLayer*) lightHorizontalGradientLayer {
    
    UIColor *colorOne = [WSFeedItemView wosGrayColor];
    UIColor *colorTwo = [UIColor darkGrayColor];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    
    [gradientLayer setStartPoint:CGPointMake(0,0.5)];
    [gradientLayer setEndPoint:CGPointMake(1,0.5)];
    
    return gradientLayer;
    
}

+ (UIColor *)wosGrayColor {
    return [UIColor colorWithRed:(60.0/255.0) green:(60.0/255.0) blue:(60.0/255.0) alpha:(60.0/255.0)];
}

@end
