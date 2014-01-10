//
//  WSRadioViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/9/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSVolumeSlider;
@class WSPlayButton;

#define WSRadioViewControllerInitialAccentColor ([[UIColor alloc] initWithRed:240.0f/255.0f green:92.0f/255.0f blue:77.0f/255.0f alpha:1.0f])

@interface WSRadioViewController : UIViewController
{
    UIColor *_accentColor;
}
@property (strong, nonatomic) IBOutlet UIColor *accentColor;
@property (strong, nonatomic) IBOutlet WSPlayButton *playButton;
@property (strong, nonatomic) IBOutlet WSVolumeSlider *volumeSlider;

@end
