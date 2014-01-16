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
    _stations = [NSMutableArray new];
    _radioModel = [[WSRadioModel alloc] init];
    self.audioPlayer = [[AudioPlayer alloc] init];
    
    typeof(self) __weak weakController = self;
    
    [_radioModel loadRadioData:^(WSRadioData *data, NSError *error) {
        NSLog(@"%@ %@", data, data.stations);
        if (!error && weakController) {
            [weakController insertStations:data.stations];
            [weakController selectedRadiostationAtIndex:0 andPlayIt:NO];
            [weakController updateNowPlayingInfoWithStation:self.currentStation andStream:self.currentStream];
        }
    }];
    self.accentColor = WSRadioViewControllerInitialAccentColor;
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    AVAudioSession *session = [ AVAudioSession sharedInstance ];
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
    

    
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionRouteChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionInterruptionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionMediaServicesWereResetNotification" object:nil];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionRouteChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionInterruptionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionMediaServicesWereResetNotification" object:nil];
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

#pragma mark - Notification handlers
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
    if ([notification.name isEqualToString:@"AVAudioSessionInterruptionNotification"]) {
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
}

- (UIColor*)accentColor {
    return _accentColor;
}

#pragma mark - Actions

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSString *log = @"Remote Control Received With Event: ";
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
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                eventName = @"UIEventSubtypeRemoteControlNextTrack";
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                eventName = @"UIEventSubtypeRemoteControlPreviousTrack";
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
    // lets pick bitrate from available streams for this radiostation
    for (WSRStream *stream in station.streams) {
        // ok 192 is the best for now
        if (stream.bitrate.integerValue == 192) {
            
            self.currentStream = stream;
            
            [self.audioPlayer stop];
            
            NSURL* url = self.currentStream.url;
            
            AutoRecoveringHttpDataSource *dataSource = [[AutoRecoveringHttpDataSource alloc] initWithHttpDataSource:[[HttpDataSource alloc] initWithURL:url]];
            [self.audioPlayer setDataSource:dataSource  withQueueItemId:url];
            
            if (shouldPlay) {
                self.playButton.isPaused = NO; // force change the button state
            }
            else {
                [self performSelector:@selector(pauseAudioPlayback) withObject:Nil afterDelay:0.1f];
            }
        }
    }
}

- (void)pauseAudioPlayback {
    [self.audioPlayer pause];
    [self updateControls];
}

- (void)resumeAudioPlayback {
    [self.audioPlayer resume];
    [self updateControls];
}

- (void)updateControls {
    switch (self.audioPlayer.state) {
        case AudioPlayerStatePlaying:
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

#pragma mark - WSPlayButtonDelegate protocol implementation

- (BOOL)playButtonShouldPlay:(WSPlayButton*)playButton {
    [self.audioPlayer resume];
    return YES;
}

- (BOOL)playButtonShouldPause:(WSPlayButton*)playButton {
    [self.audioPlayer pause];
    return YES;
}

#pragma mark - Helpers

+ (NSString*)applicationBundleDisplayName
{
    return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
}

@end
