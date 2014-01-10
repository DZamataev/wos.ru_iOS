//
//  WSVolumeSlider.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/10/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSVolumeSlider.h"

@implementation WSVolumeSlider

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

- (void)setup {
    
    self.accentColor = WSVolumeSliderInitialAccentColor;
    
    // background image
    UIImage* sliderBarImage = [UIImage imageNamed:@"ws_volume_slider_bg"];
    sliderBarImage= [sliderBarImage stretchableImageWithLeftCapWidth:4.0 topCapHeight:0.0];
    [self setMaximumTrackImage:sliderBarImage forState:UIControlStateNormal];
    
    // thumb image
    UIImage* thumbImage = [WSVolumeSlider imageWithColor:[UIColor clearColor] ofSize:CGSizeMake(10, self.frame.size.height)];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}

- (void)setMinTrackImageFromColor:(UIColor*)color
{
    UIImage *img = [WSVolumeSlider imageWithColor:color ofSize:CGSizeMake(10, self.frame.size.height)];
    img = [img stretchableImageWithLeftCapWidth:4.0f topCapHeight:0.0f];
    [self setMinimumTrackImage:img forState:UIControlStateNormal];
}

+ (UIImage *)imageWithColor:(UIColor *)color ofSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeNormal);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    return result;
}

#pragma mark - Properties

- (void)setAccentColor:(UIColor *)accentColor {
    _accentColor = accentColor;
    [self setMinTrackImageFromColor:_accentColor];
}

- (UIColor*)accentColor {
    return _accentColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
