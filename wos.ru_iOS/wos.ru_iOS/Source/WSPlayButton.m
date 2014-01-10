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
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Get the contextRef
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /* Draw a circle */
    
    // Set the circle fill color to accentColor
    CGFloat accentRed, accentGreen, accentBlue, accentAlpha;
    [self.accentColor getRed:&accentRed green:&accentGreen blue:&accentBlue alpha:&accentAlpha];
    CGContextSetRGBFillColor(ctx, accentRed, accentGreen, accentBlue, accentAlpha);
    
    // Fill the circle with the fill color
    CGContextFillEllipseInRect(ctx, rect);
    
    if (self.isPaused)
    {
        /* Draw triangle (play sign) */
    
        CGRect midRect = CGRectInset(rect, rect.size.width * 0.32f, rect.size.height * 0.32f);
        CGRect triangleRect = CGRectOffset(midRect, rect.size.width * 0.04f, 0);
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint   (ctx, CGRectGetMinX(triangleRect), CGRectGetMinY(triangleRect));  // top left
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(triangleRect), CGRectGetMidY(triangleRect));  // mid right
        CGContextAddLineToPoint(ctx, CGRectGetMinX(triangleRect), CGRectGetMaxY(triangleRect));  // bottom left
        CGContextClosePath(ctx);
        
        CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
        CGContextFillPath(ctx);
    }
    else
    {
        /* Draw two stripes (pause sign) */
        
        CGRect midRect = CGRectInset(rect, rect.size.width * 0.32f, rect.size.height * 0.32f);
        CGRect leftRect = CGRectMake(midRect.origin.x, midRect.origin.y, midRect.size.width * 0.4f, midRect.size.height);
        CGRect rightRect = CGRectMake(midRect.origin.x + midRect.size.width * 0.6, midRect.origin.y, midRect.size.width * 0.4f, midRect.size.height);
        
        CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
        CGContextFillRect(ctx, leftRect);
        CGContextFillRect(ctx, rightRect);
    }
    
}


@end
