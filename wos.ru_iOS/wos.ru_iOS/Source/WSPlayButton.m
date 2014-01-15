//
//  WSPlayButton.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/10/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSPlayButton.h"

@implementation WSPlayButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.isPaused = YES;
    self.accentColor = WSPlayButtonInitialAccentColor;
    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    /* background (circle) */
    CGRect circleFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGPoint circleAnchor = CGPointMake(CGRectGetMidX(circleFrame) / CGRectGetMaxX(circleFrame),
                                       CGRectGetMidY(circleFrame) / CGRectGetMaxY(circleFrame));
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
    
    _bgLayer = [CAShapeLayer layer];
    _bgLayer.path = path.CGPath;
    _bgLayer.anchorPoint = circleAnchor;
    _bgLayer.frame = circleFrame;
    _bgLayer.fillColor = self.accentColor.CGColor;
    [self.layer addSublayer:_bgLayer];
    
    /* play sign (triangle) */
    _playLayer = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    
    CGRect triangleMidRect = CGRectInset(rect, rect.size.width * 0.32f, rect.size.height * 0.32f);
    CGRect triangleRect = CGRectOffset(triangleMidRect, rect.size.width * 0.03f, 0);
    
    [linePath moveToPoint:CGPointMake(CGRectGetMinX(triangleRect), CGRectGetMinY(triangleRect))];
    [linePath addLineToPoint:CGPointMake(CGRectGetMaxX(triangleRect), CGRectGetMidY(triangleRect))];
    [linePath addLineToPoint:CGPointMake(CGRectGetMinX(triangleRect), CGRectGetMaxY(triangleRect))];
    
    _playLayer.path=linePath.CGPath;
    _playLayer.fillColor = [UIColor whiteColor].CGColor;
    _playLayer.opacity = 1.0;
    _playLayer.strokeColor = [UIColor whiteColor].CGColor;
    
    [self.layer addSublayer:_playLayer];
    
    /* pause sign (two rects) */
    _pauseLayer = [CAShapeLayer layer];
    CGRect pauseMidRect = CGRectInset(rect, rect.size.width * 0.35f, rect.size.height * 0.32f);
    CGRect pauseLeftRect = CGRectMake(pauseMidRect.origin.x, pauseMidRect.origin.y, pauseMidRect.size.width * 0.33f, pauseMidRect.size.height);
    CGRect pauseRightRect = CGRectMake(pauseMidRect.origin.x + pauseMidRect.size.width * 0.67, pauseMidRect.origin.y, pauseMidRect.size.width * 0.33f, pauseMidRect.size.height);
    
    CALayer *pauseLeftLayer = [CAShapeLayer layer];
    pauseLeftLayer.backgroundColor = [UIColor whiteColor].CGColor;
    pauseLeftLayer.frame = pauseLeftRect;
    [_pauseLayer addSublayer:pauseLeftLayer];
    
    CALayer *pauseRightLayer = [CAShapeLayer layer];
    pauseRightLayer.backgroundColor = [UIColor whiteColor].CGColor;
    pauseRightLayer.frame = pauseRightRect;
    [_pauseLayer addSublayer:pauseRightLayer];
    
    [self.layer addSublayer:_pauseLayer];
    
    [self hidePauseShowPlay];
}

- (void)hidePauseShowPlay
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
        _pauseLayer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _playLayer.opacity = 1.0f;
        } completion:nil];
    }];
    
}

- (void)hidePlayShowPause
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
        _playLayer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _pauseLayer.opacity = 1.0f;
        } completion:nil];
    }];
    
}

- (void)touchDown:(id)sender
{
    CGRect bgRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIBezierPath *normalPath = [UIBezierPath bezierPathWithOvalInRect:bgRect];
    UIBezierPath *smallerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(bgRect, bgRect.size.width * 0.025f, bgRect.size.height * 0.025f)];
    
    _bgLayer.path = smallerPath.CGPath; // set the final (destination) value
    
    CABasicAnimation* smallerPathAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
    smallerPathAnimation.fromValue = (id)normalPath.CGPath;
    smallerPathAnimation.toValue = (id)smallerPath.CGPath;
    smallerPathAnimation.duration  = 0.15f;
    [_bgLayer addAnimation:smallerPathAnimation forKey:@"smallerPathAnimation"];
    
    
    
}

- (void)touchUpInside:(id)sender
{
    BOOL shouldChange = NO;
    
    if (self.delegate) {
        if (self.isPaused) {
            shouldChange = [self.delegate playButtonShouldPlay:self];
        }
        else {
            shouldChange = [self.delegate playButtonShouldPause:self];
        }
    }
    
    if (shouldChange) {
        self.isPaused = !self.isPaused;
        self.isPaused ? [self hidePauseShowPlay] : [self hidePlayShowPause];
        
        [_bgLayer removeAnimationForKey:@"smallerPathAnimation"];
        
        /* pulse bg animation */
        CGRect bgRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UIBezierPath *normalPath = [UIBezierPath bezierPathWithOvalInRect:bgRect];
        UIBezierPath *biggerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(bgRect, bgRect.size.width * -0.05f, bgRect.size.height * -0.05f)];
        
        _bgLayer.path = normalPath.CGPath; // set the final (destination) value
        
        CFTimeInterval beginTime = CACurrentMediaTime();
        
        CABasicAnimation* biggerPathAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
        biggerPathAnimation.toValue = (id)biggerPath.CGPath;
        biggerPathAnimation.duration = 0.1f;
        biggerPathAnimation.beginTime = beginTime;
        [_bgLayer addAnimation:biggerPathAnimation forKey:@"biggerPathAnimation"];
        
        CABasicAnimation* normalPathAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
        normalPathAnimation.fromValue = (id)biggerPath.CGPath;
        normalPathAnimation.toValue = (id)normalPath.CGPath;
        normalPathAnimation.duration = 0.2f;
        normalPathAnimation.beginTime = biggerPathAnimation.beginTime + biggerPathAnimation.duration;
        [_bgLayer addAnimation:normalPathAnimation forKey:@"normalPathAnimation"];
    }
}

#pragma mark - Properties

- (void)setAccentColor:(UIColor *)accentColor {
    _accentColor = accentColor;
    _bgLayer.fillColor = accentColor.CGColor;
}

- (UIColor*)accentColor {
    return _accentColor;
}

- (void)setIsPaused:(BOOL)isPaused {
    _isPaused = isPaused;
    self.isPaused ? [self hidePauseShowPlay] : [self hidePlayShowPause];
}

- (BOOL)isPaused {
    return _isPaused;
}

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//}


@end
