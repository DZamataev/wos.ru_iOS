//
//  WSAutoScrollLabel.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/16/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSCopyableAutoScrollLabel.h"

@implementation WSCopyableAutoScrollLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self wsSetup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self wsSetup];
}

- (void)wsSetup
{
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self addGestureRecognizer:_longPressGestureRecognizer];
    
    _copyMenuArrowDirection = UIMenuControllerArrowDefault;
    
    _copyingEnabled = YES;
    self.userInteractionEnabled = YES;
}

#pragma mark - Public

- (void)setCopyingEnabled:(BOOL)copyingEnabled
{
    if (_copyingEnabled != copyingEnabled)
    {
        [self willChangeValueForKey:@"copyingEnabled"];
        _copyingEnabled = copyingEnabled;
        [self didChangeValueForKey:@"copyingEnabled"];
        
        self.userInteractionEnabled = copyingEnabled;
        self.longPressGestureRecognizer.enabled = copyingEnabled;
    }
}
#pragma mark - Callbacks

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.longPressGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            //            NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);
            [self becomeFirstResponder];    // must be called even when NS_BLOCK_ASSERTIONS=0
            
            UIMenuController *copyMenu = [UIMenuController sharedMenuController];
            if ([self.copyableLabelDelegate respondsToSelector:@selector(copyMenuTargetRectInCopyableLabelCoordinates:)])
            {
                [copyMenu setTargetRect:[self.copyableLabelDelegate copyMenuTargetRectInCopyableLabelCoordinates:self] inView:self];
            }
            else
            {
                [copyMenu setTargetRect:self.bounds inView:self];
            }
            copyMenu.arrowDirection = self.copyMenuArrowDirection;
            [copyMenu setMenuVisible:YES animated:YES];
        }
    }
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return self.copyingEnabled;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL retValue = NO;
    
    if (action == @selector(copy:))
    {
        if (self.copyingEnabled)
        {
            retValue = YES;
        }
	}
    else
    {
        // Pass the canPerformAction:withSender: message to the superclass
        // and possibly up the responder chain.
        retValue = [super canPerformAction:action withSender:sender];
    }
    
    return retValue;
}

- (void)copy:(id)sender
{
    if (self.copyingEnabled)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *stringToCopy;
        if ([self.copyableLabelDelegate respondsToSelector:@selector(stringToCopyForCopyableLabel:)])
        {
            stringToCopy = [self.copyableLabelDelegate stringToCopyForCopyableLabel:self];
        }
        else
        {
            stringToCopy = self.text;
        }
        
        [pasteboard setString:stringToCopy];
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
