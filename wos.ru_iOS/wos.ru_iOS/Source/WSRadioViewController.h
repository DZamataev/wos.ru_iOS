//
//  WSRadioViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/9/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

/* Frameworks & libs */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <ILTranslucentView.h>
#import <FSAudioStream.h>
#import <Parse/Parse.h>

/* Protocols */
#import "WSPlayButtonDelegate.h"
#import "WSSleepTimerPickerDelegate.h"

/* Model classes */
@class WSRadioModel;
@class WSRadioData;
@class WSRStation;
@class WSRColor;
@class WSRStream;

/* Views & controls */
@class WSVolumeSlider;
@class WSPlayButton;
@class WSRadiostationSelectorScrollView;
@class WSCopyableAutoScrollLabel;

/* Controllers */
@class WSSleepTimerViewController;
@class WSRootViewController;

/* Constants */
extern NSString * const WSPreferredBitrate_UserDefaultsKey;
extern NSString * const WSSleepTimerPickedInterval_UserDefaultsKey;

#ifdef DEBUG
#	define WSDebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define WSDebugLog(...)
#endif

@interface WSRadioViewController : UIViewController <WSPlayButtonDelegate, WSSleepTimerPickerDelegate>
{
    WSRadioModel *_radioModel;
    UIColor *_accentColor;
    NSMutableArray *_stations;
}
/* Audio player */
@property (strong, nonatomic) FSAudioStream *audioStream;

/* Accent color. Setting it will affect controls inside this controller */
@property (strong, nonatomic) UIColor *accentColor;

/* Controls */
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet WSPlayButton *playButton;
@property (strong, nonatomic) IBOutlet WSVolumeSlider *volumeSlider;
@property (strong, nonatomic) IBOutlet WSRadiostationSelectorScrollView *selector;
@property (strong, nonatomic) IBOutlet WSCopyableAutoScrollLabel *streamInfoLabel;
@property (strong, nonatomic, readonly) NSMutableArray *stations;
@property (strong, nonatomic) WSRStation *currentStation;
@property (strong, nonatomic) WSRStream *currentStream;

/* Sleep timer properties */
@property (strong, nonatomic) IBOutlet ILTranslucentView *sleepTimerViewContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sleepTimerViewContainerTopOffsetConstraint;
@property (strong, nonatomic) NSTimer *sleepTimer;

/* other */
@property (assign, nonatomic) BOOL ignoreRemoteControlEvents;

- (IBAction)toggleSleepTimerOverlayVisibility:(id)sender;

- (void)pauseAudioPlayback;
- (void)resumeAudioPlayback;

+ (void)clearSleepTimerPickedIntervalKey;
@end
