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
    self.isPaused = NO;
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
}

- (void)touchDown:(id)sender
{
    CGRect bgRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIBezierPath *normalPath = [UIBezierPath bezierPathWithOvalInRect:bgRect];
    UIBezierPath *smallerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(bgRect, bgRect.size.width * 0.025f, bgRect.size.height * 0.025f)];
    
    
    
    [CATransaction begin];
    CABasicAnimation* smallerPathAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
    smallerPathAnimation.fromValue = (id)normalPath.CGPath;
    smallerPathAnimation.toValue = (id)smallerPath.CGPath;
    smallerPathAnimation.duration  = 0.15f;
    [CATransaction setCompletionBlock:^{
        if (!_isAnimatingBiggerNormal) {
            _bgLayer.path = smallerPath.CGPath;
        }
    }];
    [_bgLayer addAnimation:smallerPathAnimation forKey:@"smallerPathAnimation"];
    [CATransaction commit];
    
    
    
}

- (void)touchUpInside:(id)sender
{
    self.isPaused = !self.isPaused;
    if (self.isPaused) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _pauseLayer.opacity = 0.0f;
        } completion:nil];
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _playLayer.opacity = 1.0f;
        } completion:nil];
       
    }
    else {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _playLayer.opacity = 0.0f;
        } completion:nil];
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _pauseLayer.opacity = 1.0f;
        } completion:nil];
    }
    
    _isAnimatingBiggerNormal = YES;
    
    [_bgLayer removeAnimationForKey:@"smallerPathAnimation"];
    
    /* pulse bg animation */
    
    CGRect bgRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIBezierPath *normalPath = [UIBezierPath bezierPathWithOvalInRect:bgRect];
    UIBezierPath *biggerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(bgRect, bgRect.size.width * -0.05f, bgRect.size.height * -0.05f)];
    
    CFTimeInterval beginTime = CACurrentMediaTime();
    
    CABasicAnimation* biggerPathAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
    biggerPathAnimation.toValue = (id)biggerPath.CGPath;
    biggerPathAnimation.duration = 0.1f;
    biggerPathAnimation.beginTime = beginTime;
    [_bgLayer addAnimation:biggerPathAnimation forKey:@"biggerPathAnimation"];
    
    [CATransaction begin];
    CABasicAnimation* normalPathAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
    normalPathAnimation.fromValue = (id)biggerPath.CGPath;
    normalPathAnimation.toValue = (id)normalPath.CGPath;
    normalPathAnimation.duration = 0.2f;
    normalPathAnimation.beginTime = biggerPathAnimation.beginTime + biggerPathAnimation.duration;
    [CATransaction setCompletionBlock:^{
        _bgLayer.path = normalPath.CGPath;
        _isAnimatingBiggerNormal = NO;
    }];
    [_bgLayer addAnimation:normalPathAnimation forKey:@"normalPathAnimation"];
    [CATransaction commit];
    
}

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Get the contextRef
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    /* Draw a circle */
//    
//    // Set the circle fill color to accentColor
//    CGFloat accentRed, accentGreen, accentBlue, accentAlpha;
//    [self.accentColor getRed:&accentRed green:&accentGreen blue:&accentBlue alpha:&accentAlpha];
//    CGContextSetRGBFillColor(ctx, accentRed, accentGreen, accentBlue, accentAlpha);
//    
//    // Fill the circle with the fill color
//    CGContextFillEllipseInRect(ctx, rect);
//    
//    
//    
//    if (self.isPaused)
//    {
//        /* Draw triangle (play sign) */
//    
//        CGRect midRect = CGRectInset(rect, rect.size.width * 0.32f, rect.size.height * 0.32f);
//        CGRect triangleRect = CGRectOffset(midRect, rect.size.width * 0.04f, 0);
//        
//        CGContextBeginPath(ctx);
//        CGContextMoveToPoint(ctx, CGRectGetMinX(triangleRect), CGRectGetMinY(triangleRect));  // top left
//        CGContextAddLineToPoint(ctx, CGRectGetMaxX(triangleRect), CGRectGetMidY(triangleRect));  // mid right
//        CGContextAddLineToPoint(ctx, CGRectGetMinX(triangleRect), CGRectGetMaxY(triangleRect));  // bottom left
//        CGContextClosePath(ctx);
//        
//        CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
//        CGContextFillPath(ctx);
//    }
//    else
//    {
//        /* Draw two stripes (pause sign) */
//        
//        CGRect midRect = CGRectInset(rect, rect.size.width * 0.35f, rect.size.height * 0.32f);
//        CGRect leftRect = CGRectMake(midRect.origin.x, midRect.origin.y, midRect.size.width * 0.33f, midRect.size.height);
//        CGRect rightRect = CGRectMake(midRect.origin.x + midRect.size.width * 0.67, midRect.origin.y, midRect.size.width * 0.33f, midRect.size.height);
//        
//        CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
//        CGContextFillRect(ctx, leftRect);
//        CGContextFillRect(ctx, rightRect);
//    }
//    
//}


@end
