//
//  WSRadioViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/9/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioPlayer.h>
#import <HttpDataSource.h>
#import <AutoRecoveringHttpDataSource.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "WSPlayButtonDelegate.h"

@class WSRadioModel;
@class WSRadioData;
@class WSRStation;
@class WSRColor;
@class WSRStream;

@class WSVolumeSlider;
@class WSPlayButton;
@class WSRadiostationSelectorScrollView;

#define WSRadioViewControllerInitialAccentColor ([[UIColor alloc] initWithRed:240.0f/255.0f green:92.0f/255.0f blue:77.0f/255.0f alpha:1.0f])

@interface WSRadioViewController : UIViewController <WSPlayButtonDelegate>
{
    WSRadioModel *_radioModel;
    UIColor *_accentColor;
    NSMutableArray *_stations;
}
@property (readwrite, retain) AudioPlayer* audioPlayer;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIColor *accentColor;
@property (strong, nonatomic) IBOutlet WSPlayButton *playButton;
@property (strong, nonatomic) IBOutlet WSVolumeSlider *volumeSlider;
@property (strong, nonatomic) IBOutlet WSRadiostationSelectorScrollView *selector;
@property (strong, nonatomic, readonly) NSMutableArray *stations;
@property (strong, nonatomic) WSRStation *currentStation;
@property (strong, nonatomic) WSRStream *currentStream;

- (void)pauseAudioPlayback;
- (void)resumeAudioPlayback;
- (void)updateControls;
@end
