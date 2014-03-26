//
//  WSWindow.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/24/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSWindow.h"

@implementation WSWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSRemoteControlRecevedWithEventNotification"
                                                        object:nil
                                                      userInfo:@{ @"event" : event }];
}

@end
