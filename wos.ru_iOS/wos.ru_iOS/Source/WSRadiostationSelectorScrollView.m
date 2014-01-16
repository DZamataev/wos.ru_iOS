//
//  WSRadiostationSelectorScrollView.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSRadiostationSelectorScrollView.h"
#import "WSRadiostationButton.h"

@implementation WSRadiostationSelectorScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    _buttons = [NSMutableArray new];
}

- (void)addButtonsWithTitles:(NSArray*)titles andColors:(NSArray*)colors andSelectionCallback:(void (^)(WSRadiostationButton *button, NSInteger index))selectionCallback
{
    _buttonSelectedCallback = selectionCallback;
    
    if (_backgroundPatternView) {
        [_backgroundPatternView removeFromSuperview];
    }
    
    _backgroundPatternView = [[UIView alloc] init];
    _backgroundPatternView.layer.mask = [CALayer layer];
    _backgroundPatternView.layer.mask.backgroundColor = [UIColor blackColor].CGColor;
    
    float contentHeight = 0.0f;
    float contentWidth = 0.0f;
    for (int i = 0; i < titles.count && i < colors.count; i++) {
        NSString *title = titles[i];
        UIColor *color = colors[i];
        
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WSRadiostationButton class])
                                                          owner:self
                                                        options:nil];
        WSRadiostationButton *button = nibViews[0];
        
        button.titleLabel.text = title;
        CGRect buttonFrame = CGRectMake(0, i*button.frame.size.height, button.frame.size.width, button.frame.size.height);
        button.frame = buttonFrame;
        
        CALayer *partOfBackgroundPattern = [CALayer layer];
        partOfBackgroundPattern.frame = buttonFrame;
        partOfBackgroundPattern.backgroundColor = color.CGColor;
        [_backgroundPatternView.layer addSublayer: partOfBackgroundPattern];
        
        [_buttons addObject:button];
        [self addSubview:button];
        
        contentHeight = buttonFrame.origin.y + buttonFrame.size.height;
        contentWidth = MAX(contentWidth, buttonFrame.size.width);
        
        /* setup callbacks */
        typeof(self) __weak weakView = self;
        [button setTouchUpInsideCallback:^(WSRadiostationButton *sender) {
            if (weakView) {
                [weakView visuallySelectButton:sender];
                weakView.buttonSelectedCallback(sender, [_buttons indexOfObject:sender]);
            }
        }];
        
    }
    
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
    
    _backgroundPatternView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    WSRadiostationButton *firstButton = _buttons.count ? _buttons[0] : nil;
    _backgroundPatternView.layer.mask.frame = CGRectMake(0, 0, self.contentSize.width, firstButton ? firstButton.frame.size.height : 0);
    
    [self addSubview:_backgroundPatternView];
    [self sendSubviewToBack:_backgroundPatternView];
}

- (void)visuallySelectButton:(WSRadiostationButton*)button
{
    if (self.buttonSelectedCallback && _buttons && _buttons.count && [_buttons indexOfObject:button] != NSNotFound) {
        NSInteger prevSelectedButtonIndex = _selectedButtonIndex;
        _selectedButtonIndex = [_buttons indexOfObject:button];
        
        if (_backgroundPatternView.layer.mask) {
            NSInteger wayToGo = abs(prevSelectedButtonIndex - _selectedButtonIndex);
            float duration = wayToGo * 0.2f;
            
            NSLog(@"duration : %f", duration);
            
            CGRect targetFrame = button.frame;
            CGPoint targetPosition = CGPointMake(targetFrame.origin.x+targetFrame.size.width/2.0f, targetFrame.origin.y+targetFrame.size.height/2.0f);
            
            [UIView beginAnimations:@"maskAnimation" context:nil];
            [UIView setAnimationDuration:duration];
            [UIView commitAnimations];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            
            _backgroundPatternView.layer.mask.position = targetPosition;
            [CATransaction commit];
            
            
//            CABasicAnimation* maskFrameAnimation = [CABasicAnimation animationWithKeyPath: @"position"];
//            maskFrameAnimation.fromValue = (id)[NSValue valueWithCGPoint:CGPointMake(maskFrame.origin.x+maskFrame.size.width/2.0f, maskFrame.origin.y+maskFrame.size.height/2.0f)];
//            maskFrameAnimation.toValue = (id)[NSValue valueWithCGPoint:CGPointMake(targetFrame.origin.x+targetFrame.size.width/2.0f, targetFrame.origin.y+targetFrame.size.height/2.0f)];
//            maskFrameAnimation.duration = duration;
//            [UIView setAnimationDidStopSelector:@selector(endAnimating)];
//            [_backgroundPatternView.layer.mask addAnimation:maskFrameAnimation forKey:@"maskFrameAnimation"];
        }
    }
}

- (void)endAnimating
{
}

- (void)visuallySelectButtonAtIndex:(NSInteger)index
{
    if (_buttons.count > index) {
        [self visuallySelectButton:_buttons[index]];
    }
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
