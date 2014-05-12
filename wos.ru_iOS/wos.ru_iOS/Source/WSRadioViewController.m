//
//  WSRadioViewController.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/9/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSRadioViewController.h"

#import "WSRadioModel.h"
#import "WSRadioData.h"
#import "WSRStation.h"
#import "WSRColor.h"
#import "WSRStream.h"

#import "WSVolumeSlider.h"
#import "WSPlayButton.h"
#import "WSRadiostationSelectorScrollView.h"

#import "WSSleepTimerPickerViewController.h"
#import "WSRootViewController.h"

NSString * const WSPreferredBitrate_UserDefaultsKey = @"PreferredBitrate";
NSString * const WSSleepTimerPickedInterval_UserDefaultsKey = @"SleepTimerPickedInterval";

@interface WSRadioViewController ()

@end

@implementation WSRadioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resignListeningNotifications];
    
    _stations = [NSMutableArray new];
    _radioModel = [[WSRadioModel alloc] init];
    self.audioPlayer = [[STKAudioPlayer alloc] init];
    self.audioPlayer.delegate = self;
    
    [self loadRadiostations];

    self.accentColor = [WSRootViewController defaultAccentColor];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    for (id vc in self.childViewControllers) {
        if ([vc isKindOfClass:[WSSleepTimerPickerViewController class]]) {
            WSSleepTimerPickerViewController* sleepTimerPickerVC = vc;
            sleepTimerPickerVC.delegate = self;
        }
    }
    
    [self becomeFirstResponder];
    
//    [self performSelector:@selector(logtick) withObject:nil afterDelay:1.0f];
}

- (void)logtick
{
    NSLog(@"log: radio is f.r. %i", (int)self.isFirstResponder);
//    if (!self.isFirstResponder) {
//        [self becomeFirstResponder];
//    }
    [self performSelector:@selector(logtick) withObject:nil afterDelay:1.0f];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self unsignListeningNotifications];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)resignListeningNotifications
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // Register for Route Change notifications
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleRouteChange:)
                                                 name: AVAudioSessionRouteChangeNotification
                                               object: session];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleInterruption:)
                                                 name: AVAudioSessionInterruptionNotification
                                               object: session];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleMediaServicesWereReset:)
                                                 name: AVAudioSessionMediaServicesWereResetNotification
                                               object: session];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoteControlReceivedWithEventNotification:)
                                                 name:@"WSRemoteControlRecevedWithEventNotification" object:nil];
}

- (void)unsignListeningNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionMediaServicesWereResetNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WSRemoteControlRecevedWithEventNotification" object:nil];
}

#pragma mark - Notification handlers

- (void)handleRemoteControlReceivedWithEventNotification:(NSNotification *)notification
{
    UIEvent *event = notification.userInfo[@"event"];
    [self remoteControlReceivedWithEvent:event];
}

-(void)handleMediaServicesWereReset:(NSNotification*)notification{
    //  If the media server resets for any reason, handle this notification to reconfigure audio or do any housekeeping, if necessary
    //    • No userInfo dictionary for this notification
    //      • Audio streaming objects are invalidated (zombies)
    //      • Handle this notification by fully reconfiguring audio
    NSLog(@"handleMediaServicesWereReset: %@ ",[notification name]);
    [self pauseAudioPlayback];
}

-(void)handleInterruption:(NSNotification*)notification{
    NSInteger reason = 0;
    NSString* reasonStr=@"";
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        //Posted when an audio interruption occurs.
        reason = [[[notification userInfo] objectForKey:@" AVAudioSessionInterruptionTypeKey"] integerValue];
        if (reason == AVAudioSessionInterruptionTypeBegan) {
            //       Audio has stopped, already inactive
            //       Change state of UI, etc., to reflect non-playing state
            [self pauseAudioPlayback];
        }
        
        if (reason == AVAudioSessionInterruptionTypeEnded) {
            //       Make session active
            //       Update user interface
            //       AVAudioSessionInterruptionOptionShouldResume option
            reasonStr = @"AVAudioSessionInterruptionTypeEnded";
            NSNumber* seccondReason = [[notification userInfo] objectForKey:@"AVAudioSessionInterruptionOptionKey"] ;
            switch ([seccondReason integerValue]) {
                case AVAudioSessionInterruptionOptionShouldResume:
                    //          Indicates that the audio session is active and immediately ready to be used. Your app can resume the audio operation that was interrupted.
                    [self resumeAudioPlayback];
                    break;
                default:
                    [self pauseAudioPlayback];
                    break;
            }
        }
        
        if ([notification.name isEqualToString:@"AVAudioSessionDidBeginInterruptionNotification"]) {
            //      Posted after an interruption in your audio session occurs.
            //      This notification is posted on the main thread of your app. There is no userInfo dictionary.
        }
        if ([notification.name isEqualToString:@"AVAudioSessionDidEndInterruptionNotification"]) {
            //      Posted after an interruption in your audio session ends.
            //      This notification is posted on the main thread of your app. There is no userInfo dictionary.
        }
        if ([notification.name isEqualToString:@"AVAudioSessionInputDidBecomeAvailableNotification"]) {
            //      Posted when an input to the audio session becomes available.
            //      This notification is posted on the main thread of your app. There is no userInfo dictionary.
        }
        if ([notification.name isEqualToString:@"AVAudioSessionInputDidBecomeUnavailableNotification"]) {
            //      Posted when an input to the audio session becomes unavailable.
            //      This notification is posted on the main thread of your app. There is no userInfo dictionary.
        }
        
    };
    NSLog(@"handleInterruption: %@ reason %@",[notification name],reasonStr);
}

-(void)handleRouteChange:(NSNotification*)notification{
    NSString* seccReason = @"";
    NSInteger  reason = [[[notification userInfo] objectForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    //  AVAudioSessionRouteDescription* prevRoute = [[notification userInfo] objectForKey:AVAudioSessionRouteChangePreviousRouteKey];
    switch (reason) {
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            seccReason = @"The route changed because no suitable route is now available for the specified category.";
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            seccReason = @"The route changed when the device woke up from sleep.";
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            seccReason = @"The output route was overridden by the app.";
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            seccReason = @"The category of the session object changed.";
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            seccReason = @"The previous audio output path is no longer available.";
            break;
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            seccReason = @"A preferred new audio output path is now available.";
            break;
        case AVAudioSessionRouteChangeReasonUnknown:
        default:
            seccReason = @"The reason for the change is unknown.";
            break;
    }
    
    NSLog(@"handleRouteChange: %@ reason %@", [notification name], seccReason);
    
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        NSLog(@"will pause playback beacause device became unavailable (usually headphones unplugged)");
        [self pauseAudioPlayback];
    }
}

#pragma mark - Properties

//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setAccentColor:(UIColor *)accentColor
{
    _accentColor = accentColor;
    self.playButton.accentColor = _accentColor;
    self.volumeSlider.accentColor = _accentColor;
    [[[UIApplication sharedApplication] keyWindow] setTintColor:_accentColor];
}

- (UIColor*)accentColor {
    return _accentColor;
}

#pragma mark - Actions

- (void)loadRadiostations {
    [self.activityIndicator startAnimating];
    typeof(self) __weak weakController = self;
    [_radioModel loadRadioData:^(WSRadioData *data, NSError *error) {
        NSLog(@"Successfully loaded stations: %@ %@", data, data.stations);
        if (!error && weakController) {
            [weakController.activityIndicator stopAnimating];
            [weakController insertStations:data.stations];
            [weakController selectedRadiostationAtIndex:0 andPlayIt:NO];
            [weakController updateNowPlayingInfoWithStation:self.currentStation andStream:self.currentStream];
        }
        else {
            CGFloat timeTillRetry = 5.0f;
            NSLog(@"Error loading radiostations list. Retry in %f.", timeTillRetry);
            [self performSelector:@selector(loadRadiostations) withObject:nil afterDelay:timeTillRetry];
        }
    }];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSString *log = @"Remote Control received with event: ";
    NSString *eventName = nil;
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                eventName = @"UIEventSubtypeRemoteControlPlay";
                [self resumeAudioPlayback];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                eventName = @"UIEventSubtypeRemoteControlPause";
                [self pauseAudioPlayback];
                break;
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                eventName = @"UIEventSubtypeRemoteControlTogglePlayPause";
                if (self.audioPlayer.state == STKAudioPlayerStatePlaying) {
                    [self pauseAudioPlayback];
                }
                else if (self.audioPlayer.state == STKAudioPlayerStatePaused) {
                    [self resumeAudioPlayback];
                }
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                eventName = @"UIEventSubtypeRemoteControlNextTrack";
                [self playNextStation];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                eventName = @"UIEventSubtypeRemoteControlPreviousTrack";
                [self playPreviousStation];
                break;
                
            case UIEventSubtypeRemoteControlStop:
                eventName = @"UIEventSubtypeRemoteControlStop";
                break;
                
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                eventName = @"UIEventSubtypeRemoteControlBeginSeekingBackward";
                break;
                
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                eventName = @"UIEventSubtypeRemoteControlBeginSeekingForward";
                break;
                
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                eventName = @"UIEventSubtypeRemoteControlEndSeekingBackward";
                break;
                
            case UIEventSubtypeRemoteControlEndSeekingForward:
                eventName = @"UIEventSubtypeRemoteControlEndSeekingForward";
                break;
                
            case UIEventSubtypeNone:
                eventName = @"UIEventSubtypeNone";
                break;
                
            default:
                break;
        }
    }
    NSLog(@"%@%@", log, eventName);
}

- (void)insertStations:(NSArray*)stations
{
    NSMutableArray *titles = [NSMutableArray new];
    NSMutableArray *colors = [NSMutableArray new];
    
    for (WSRStation *station in stations) {
        [_stations addObject:station];
        [titles addObject:station.name];
        [colors addObject:station.color.UIColorFromComponents];
    }
    
    typeof(self) __weak weakController = self;
    
    [self.selector addButtonsWithTitles:titles andColors:colors andSelectionCallback:^(WSRadiostationButton *button, NSInteger index) {
        if (weakController) {
            [weakController selectedRadiostationAtIndex:index andPlayIt:YES];
            [weakController updateNowPlayingInfoWithStation:weakController.currentStation andStream:weakController.currentStream];
        }
    }];
}

- (void)takeColorFromStationAtIndex:(NSInteger)index
{
    if (index != NSNotFound && _stations.count > index) {
        WSRStation *station = _stations[index];
        self.accentColor = station.color.UIColorFromComponents;
    }
}

- (void)selectedRadiostationAtIndex:(NSInteger)index andPlayIt:(BOOL)shouldPlay
{
    if (index != NSNotFound && _stations.count > index) {
        self.currentStation = _stations[index];
        
        self.accentColor = self.currentStation.color.UIColorFromComponents;
        
        [self findStreamForRadiostation:self.currentStation andPlayIt:shouldPlay];
    }
}

- (void)findStreamForRadiostation:(WSRStation*)station andPlayIt:(BOOL)shouldPlay
{
    // get preffered bitrate from user defaults. It can be changed via Settings.app
    NSString *preferredBitrateString = [[NSUserDefaults standardUserDefaults] objectForKey:WSPreferredBitrate_UserDefaultsKey];
    if (preferredBitrateString == nil) preferredBitrateString = @"192";
    NSInteger preferredBitrateInteger = [preferredBitrateString integerValue];
    
    // lets pick bitrate from available streams for this radiostation
    // we test for equality with bitrate saved in settings
    for (WSRStream *stream in station.streams) {
        
        if (stream.bitrate.integerValue == preferredBitrateInteger) {
            
            self.currentStream = stream;
            
            [self.audioPlayer stop];
            
            if (shouldPlay) {
                STKAutoRecoveringHTTPDataSource *dataSource = [self dataSourceWithStream:self.currentStream];
                dataSource.delegate = self;
                [self.audioPlayer setDataSource:dataSource  withQueueItemId:stream.url];
                self.playButton.isPaused = NO; // force change the button state
            }
            else {
                self.dataSourceToSetOnResume = [self dataSourceWithStream:self.currentStream];
            }
        }
    }
}

- (STKAutoRecoveringHTTPDataSource*)dataSourceWithStream:(WSRStream*)stream
{
    NSURL* url = self.currentStream.url;
    NSLog(@"Attempt to set url as data source: %@", url);
    STKAutoRecoveringHTTPDataSource *dataSource = [[STKAutoRecoveringHTTPDataSource alloc] initWithHTTPDataSource:[[STKHTTPDataSource alloc] initWithURL:url]];
    return dataSource;
}

- (void)pauseAudioPlayback {
    [self.audioPlayer pause];
    [self performSelector:@selector(updateControls) withObject:nil afterDelay:0.1f];
}

- (void)resumeAudioPlayback {
    if (self.dataSourceToSetOnResume) {
        
        self.dataSourceToSetOnResume.delegate = self;
        [self.audioPlayer setDataSource:self.dataSourceToSetOnResume withQueueItemId:stream.url];
        self.playButton.isPaused = NO; // force change the button state
    }
    [self.audioPlayer resume];
    [self performSelector:@selector(updateControls) withObject:nil afterDelay:0.1f];
}

- (void)playNextStation {
    if (self.currentStation && _stations.count) {
        NSInteger index = [_stations indexOfObject:self.currentStation];
        if (index != NSNotFound) {
            index += 1;
            index = index % _stations.count;
            [self.selector visuallySelectButtonAtIndex:index];
            [self selectedRadiostationAtIndex:index andPlayIt:YES];
            [self updateNowPlayingInfoWithStation:self.currentStation andStream:self.currentStream];
        }
    }
}

- (void)playPreviousStation {
    if (self.currentStation && _stations.count) {
        NSInteger index = [_stations indexOfObject:self.currentStation];
        if (index != NSNotFound) {
            index -= 1;
            if (index < 0)
                index = _stations.count - 1;
            else
                index = index % _stations.count;
            [self.selector visuallySelectButtonAtIndex:index];
            [self selectedRadiostationAtIndex:index andPlayIt:YES];
            [self updateNowPlayingInfoWithStation:self.currentStation andStream:self.currentStream];
        }
    }
}

- (void)updateControls {
    switch (self.audioPlayer.state ) {
        case STKAudioPlayerStatePlaying:
            self.playButton.isPaused = NO;
            break;
            
        default:
            self.playButton.isPaused = YES;
            break;
    }
}

- (void)updateNowPlayingInfoWithStation:(WSRStation*)station andStream:(WSRStream*)stream {
    NSDictionary *nowPlaying = @{MPMediaItemPropertyArtist: [WSRadioViewController applicationBundleDisplayName],
                                 MPMediaItemPropertyAlbumTitle: station.name,
                                 // MPMediaItemPropertyPlaybackDuration: [NSNumber numberWithDouble:320.0],
                                 // MPNowPlayingInfoPropertyPlaybackRate:@1.0f
                                 //, MPMediaItemPropertyArtwork:[songMedia valueForProperty:MPMediaItemPropertyArtwork]
                                 };
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlaying];
}

- (IBAction)toggleSleepTimerOverlayVisibility:(id)sender
{
    if (self.sleepTimerViewContainerTopOffsetConstraint.constant != 0) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.sleepTimerViewContainerTopOffsetConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
        for (WSSleepTimerPickerViewController* sleepTimerPickerVC in self.childViewControllers) {
            [sleepTimerPickerVC selectActualItem:self];
        }
    }
    else if (self.sleepTimerViewContainerTopOffsetConstraint.constant == 0) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.sleepTimerViewContainerTopOffsetConstraint.constant = self.view.bounds.size.height;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)setupSleepTimerWithInterval:(int)minutes {
    if (self.sleepTimer) [self.sleepTimer invalidate];
    int fireTime = minutes*60;
    self.sleepTimer = [NSTimer scheduledTimerWithTimeInterval:fireTime
                                                       target:self
                                                     selector:@selector(sleepTimerTick:)
                                                     userInfo:nil
                                                      repeats:NO];
    [[NSUserDefaults standardUserDefaults] setObject:@(fireTime) forKey:WSSleepTimerPickedInterval_UserDefaultsKey];
    WSDebugLog(@"Sleep timer setup done. Will fire in %i seconds", fireTime);
}

- (void)sleepTimerTick:(NSTimer *)timer
{
    WSDebugLog(@"Sleep timer fired");
    [self pauseAudioPlayback];
    [WSRadioViewController clearSleepTimerPickedIntervalKey];
}

- (void)disableSleepTimer {
    if (self.sleepTimer) [self.sleepTimer invalidate];
    [WSRadioViewController clearSleepTimerPickedIntervalKey];
}

+ (void)clearSleepTimerPickedIntervalKey {
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:WSSleepTimerPickedInterval_UserDefaultsKey];
}

- (IBAction)slideToFeed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSSlideToFeed" object:nil userInfo:nil];
}

#pragma mark - WSPlayButtonDelegate protocol implementation

- (BOOL)playButtonShouldPlay:(WSPlayButton*)playButton {
    [self.audioPlayer resume];
    return YES;
}

- (BOOL)playButtonShouldPause:(WSPlayButton*)playButton {
    [self.audioPlayer pause];
    return YES;
}

#pragma mark - AudioPlayerDelegate protocol implementation


/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId{
    WSDebugLog();
}
/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
    WSDebugLog();
}
/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    WSDebugLog();
}
/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    WSDebugLog();
}
/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    WSDebugLog();
}

/// Optionally implemented to get logging information from the STKAudioPlayer (used internally for debugging)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer logInfo:(NSString*)line{
    WSDebugLog();
}
/// Raised when items queued items are cleared (usually because of a call to play, setDataSource or stop)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didCancelQueuedItems:(NSArray*)queuedItems{
    WSDebugLog();
}


#pragma mark - DataSourceDelegate protocol implementation
-(void) dataSourceDataAvailable:(STKDataSource*)dataSource {
    WSDebugLog();
}

-(void) dataSourceErrorOccured:(STKDataSource*)dataSource {
    WSDebugLog();
}

-(void) dataSourceEof:(STKDataSource*)dataSource {
    WSDebugLog();
}

#pragma mark - WSSleepTimerPickerDelegate protocol implementation
- (void)sleepTimerPickerViewController:(WSSleepTimerPickerViewController *)pickerController pickedTimeInterval:(NSNumber *)timeInterval
{
    if (timeInterval.intValue > 0) {
        [self setupSleepTimerWithInterval:timeInterval.intValue];
    }
    else {
        [self disableSleepTimer];
    }
    [self performSelector:@selector(toggleSleepTimerOverlayVisibility:) withObject:self afterDelay:0.5f];
}

#pragma mark - Helpers

+ (NSString*)applicationBundleDisplayName
{
    return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
}

@end
