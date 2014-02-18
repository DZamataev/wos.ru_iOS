//
//  WSRadioViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/9/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Radio.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <ILTranslucentView.h>
#import "WSPlayButtonDelegate.h"
#import "WSSleepTimerPickerDelegate.h"

@class WSRadioModel;
@class WSRadioData;
@class WSRStation;
@class WSRColor;
@class WSRStream;

@class WSVolumeSlider;
@class WSPlayButton;
@class WSRadiostationSelectorScrollView;

@class WSSleepTimerViewController;

#define WSRadioViewControllerInitialAccentColor ([[UIColor alloc] initWithRed:240.0f/255.0f green:92.0f/255.0f blue:77.0f/255.0f alpha:1.0f])

extern NSString * const WSPreferredBitrate_UserDefaultsKey;
extern NSString * const WSSleepTimerPickedInterval_UserDefaultsKey;

#ifdef DEBUG
#	define WSDebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define WSDebugLog(...)
#endif

@interface WSRadioViewController : UIViewController <WSPlayButtonDelegate, WSSleepTimerPickerDelegate, RadioDelegate>
{
    WSRadioModel *_radioModel;
    UIColor *_accentColor;
    NSMutableArray *_stations;
}
@property (strong, nonatomic) Radio* audioPlayer;
@property (assign, nonatomic) BOOL isPlaying;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIColor *accentColor;
@property (strong, nonatomic) IBOutlet WSPlayButton *playButton;
@property (strong, nonatomic) IBOutlet WSVolumeSlider *volumeSlider;
@property (strong, nonatomic) IBOutlet WSRadiostationSelectorScrollView *selector;
@property (strong, nonatomic, readonly) NSMutableArray *stations;
@property (strong, nonatomic) WSRStation *currentStation;
@property (strong, nonatomic) WSRStream *currentStream;
@property (strong, nonatomic) NSString *currentSongName;
@property (strong, nonatomic) IBOutlet ILTranslucentView *sleepTimerViewContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sleepTimerViewContainerTopOffsetConstraint;
@property (strong, nonatomic) NSTimer *sleepTimer;

- (IBAction)toggleSleepTimerOverlayVisibility:(id)sender;
- (void)pauseAudioPlayback;
- (void)resumeAudioPlayback;
- (void)updateControls;

+ (void)clearSleepTimerPickedIntervalKey;
@end
