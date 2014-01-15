//
//  WSPlayButton.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/10/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CPAnimationChain.h>
#import <CPAnimationLink.h>

#import "WSPlayButtonDelegate.h"

#define WSPlayButtonInitialAccentColor ([[UIColor alloc] initWithRed:240.0f/255.0f green:92.0f/255.0f blue:77.0f/255.0f alpha:1.0f])

@interface WSPlayButton : UIControl
{    
    CAShapeLayer *_bgLayer;
    CAShapeLayer *_playLayer;
    CAShapeLayer *_pauseLayer;
    
    UIColor *_accentColor;
    BOOL _isPaused;
}
@property (assign, nonatomic) IBOutlet id<WSPlayButtonDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIColor *accentColor;
@property (assign, nonatomic) BOOL isPaused;
@end
