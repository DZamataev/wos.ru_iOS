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
        typeof(selectionCallback) __weak weakSelectionCallback = selectionCallback;
        typeof(_buttons) __weak weakButtonsArray = _buttons;
        typeof(_backgroundPatternView.layer.mask) __weak weakPatternViewMask = _backgroundPatternView.layer.mask;
        
        [button setTouchUpInsideCallback:^(WSRadiostationButton *sender) {
            if (weakSelectionCallback && weakButtonsArray) {
                if (weakPatternViewMask) {
                    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        weakPatternViewMask.frame = sender.frame;
                    } completion:nil];
                }
                weakSelectionCallback(sender, [weakButtonsArray indexOfObject:sender]);
            }
        }];
        
    }
    
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
    
    _backgroundPatternView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    WSRadiostationButton *firstButton = _buttons.count ? _buttons[0] : nil;
    _backgroundPatternView.layer.mask.frame = CGRectMake(0, 0, self.contentSize.width, firstButton ? firstButton.frame.size.height : 0);
    
    [self addSubview:_backgroundPatternView];
    [self sendSubviewToBack:_backgroundPatternView];
    
    NSLog(@"pattern view frame %@", NSStringFromCGRect(_backgroundPatternView.frame));
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
