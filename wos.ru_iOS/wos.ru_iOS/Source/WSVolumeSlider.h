//
//  WSVolumeSlider.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/10/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "WSRootViewController.h"

#define WSVolumeSliderInitialAccentColor ([WSRootViewController defaultAccentColor])

@interface WSVolumeSlider : MPVolumeView
{
    UIColor *_accentColor;
}

@property (strong, nonatomic) IBOutlet UIColor *accentColor;
- (IBAction)volumeUp:(id)sender;
- (IBAction)volumeDown:(id)sender;
@end
