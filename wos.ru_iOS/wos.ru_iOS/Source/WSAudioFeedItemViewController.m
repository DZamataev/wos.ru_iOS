//
//  WSAudioFeedItemViewController.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/29/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSAudioFeedItemViewController.h"

@interface WSAudioFeedItemViewController ()

@end

@implementation WSAudioFeedItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _storedValues = [NSMutableDictionary new];
    self.ignoreRemoteControlEvents = YES;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRemoteControlReceivedWithEventNotification:)
                                                 name:@"WSRemoteControlRecevedWithEventNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAnotherAudioPlaybackInApplicationBecomesActiveNotification:)
                                                 name:@"WSAnotherAudioPlaybackInApplicationBecomesActive"
                                               object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionMediaServicesWereResetNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"WSRemoteControlRecevedWithEventNotification"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"WSAnotherAudioPlaybackInApplicationBecomesActive"
                                                  object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleRemoteControlReceivedWithEventNotification:(NSNotification *)notification
{
    UIEvent *event = notification.userInfo[@"event"];
    [self remoteControlReceivedWithEvent:event];
}

- (void)handleAnotherAudioPlaybackInApplicationBecomesActiveNotification:(NSNotification*)notification
{
    if (![notification.userInfo[@"source"] isEqualToString:@"feed"] ||
        ![notification.userInfo[@"streamUrlString"] isEqualToString:_currentlyPlayingURL.absoluteString]) {
        [self pauseInView:self.audioView];
        self.ignoreRemoteControlEvents = YES;
    }
}

-(void)handleMediaServicesWereReset:(NSNotification*)notification{
    //  If the media server resets for any reason, handle this notification to reconfigure audio or do any housekeeping, if necessary
    //    • No userInfo dictionary for this notification
    //      • Audio streaming objects are invalidated (zombies)
    //      • Handle this notification by fully reconfiguring audio
    NSLog(@"handleMediaServicesWereReset: %@ ",[notification name]);
    [self pauseInView:self.audioView];
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
            [self pauseInView:self.audioView];
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
                    
                    //          [self resumeAudioPlayback]; // causes problems
                    break;
                default:
                    [self pauseInView:self.audioView];
                    break;
            }
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
        
        [self pauseInView:self.audioView];
    }
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (self.ignoreRemoteControlEvents) {
        return;
    }
    
    NSString *log = @"Remote Control received with event: ";
    NSString *eventName = nil;
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                eventName = @"UIEventSubtypeRemoteControlPlay";
                [self playInView:self.audioView];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                eventName = @"UIEventSubtypeRemoteControlPause";
                [self pauseInView:self.audioView];
                break;
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                eventName = @"UIEventSubtypeRemoteControlTogglePlayPause";
                if (self.audioPlayer.state == STKAudioPlayerStatePlaying || self.audioPlayer.state == STKAudioPlayerStateBuffering) {
                    [self pauseInView:self.audioView];
                }
                else {
                    [self playInView:self.audioView];
                }
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

- (void)configureView:(WSAudioFeedItemView*)view withStreamUrl:(NSURL*)streamUrl
{
    self.audioView = view;
    view.delegate = self;
    view.streamUrl = streamUrl;
    
    view.isPaused =  self.audioPlayer.state == STKAudioPlayerStatePlaying || self.audioPlayer.state == STKAudioPlayerStateBuffering ? NO : YES;
    
    [view startUpdatingSlider];
    
    NSDictionary *storedValuesForUrl = [_storedValues objectForKey:streamUrl.absoluteString];
    if (storedValuesForUrl) {
        view.progressBar.value = [storedValuesForUrl[@"slider"] floatValue];
        view.timePosLabel.text = storedValuesForUrl[@"progress"];
        view.durationLabel.text = storedValuesForUrl[@"duration"];
    }
    else {
        view.progressBar.value = 0;
        view.timePosLabel.text = [self getStringFromTime:0];
        view.durationLabel.text = [self getStringFromTime:0];
    }
}

- (void)prepareViewForReuse:(WSAudioFeedItemView*)view
{
    view.delegate = nil;
    view.streamUrl = nil;
    view.isPaused = YES;
    view.progressBar.value = 0;
    view.timePosLabel.text = [self getStringFromTime:0];
    view.durationLabel.text = [self getStringFromTime:0];
    [view endUpdatingSlider];
    self.audioView = nil;
}

- (void)playInView:(WSAudioFeedItemView*)view
{
    if (!self.audioPlayer)
    {
        self.audioPlayer = [[STKAudioPlayer alloc] init];
        self.audioPlayer.delegate = self;
    }
    
    if (!_currentlyPlayingURL) {
        _currentlyPlayingURL = view.streamUrl;
        [self.audioPlayer playURL:_currentlyPlayingURL];
    }
    else {
        [self.audioPlayer resume];
    }
    
    [view startUpdatingSlider];
    
    self.ignoreRemoteControlEvents = NO;
    
    [WSAudioFeedItemViewController updateNowPlayingInfo:self.artistInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSAnotherAudioPlaybackInApplicationBecomesActive"
                                                        object:nil
                                                      userInfo:@{@"source":@"feed",
                                                                 @"streamUrlString" : _currentlyPlayingURL.absoluteString}];
    
    // Analytics
    [PFAnalytics trackEvent:@"audio material play"];
    //
}

- (void)pauseInView:(WSAudioFeedItemView*)view
{
    [_audioPlayer pause];
    [view endUpdatingSlider];
    // Analytics
    [PFAnalytics trackEvent:@"audio material pause"];
    //
}

-(BOOL)audioView:(WSAudioFeedItemView*)sender shouldChangeToPaused:(BOOL)isPaused progressBar:(UISlider *)slider
{
    if (isPaused) {
        // should pause
        [self pauseInView:sender];
    }
    else {
        // should play
        [self playInView:sender];
    }
    return YES;
}

- (void)updateTimeInView:(WSAudioFeedItemView*)view
{
    view.progressBar.value = self.audioPlayer.progress / self.audioPlayer.duration;
    view.timePosLabel.text = [self getStringFromTime:self.audioPlayer.progress];
    view.durationLabel.text = [self getStringFromTime:self.audioPlayer.duration];
}


#pragma mark - WSAuidoFeedItemView delegate protocol implementation

-(void)audioView:(WSAudioFeedItemView *)sender progressBarUpdateTick:(UISlider *)slider
{
    [self updateTimeInView:sender];

    [_storedValues setObject:@{@"slider":[NSNumber numberWithFloat:slider.value],
                                      @"progress":sender.timePosLabel.text,
                                      @"duration":sender.durationLabel.text}
                             forKey:sender.streamUrl.absoluteString];
}

-(void)audioView:(WSAudioFeedItemView*)sender progressBarChanged:(UISlider *)slider
{
    if (_currentlyPlayingURL) {
        [self pauseInView:sender];
        [self.audioPlayer seekToTime:slider.value * self.audioPlayer.duration];
        [self updateTimeInView:sender];
    }
    
    
    [_storedValues setObject:@{@"slider":[NSNumber numberWithFloat:slider.value],
                                      @"progress":sender.timePosLabel.text,
                                      @"duration":sender.durationLabel.text}
                             forKey:sender.streamUrl.absoluteString];
}

-(void)audioView:(WSAudioFeedItemView*)sender proressBarChangeEnded:(UISlider *)slider
{
    [self playInView:sender];
    
    [self updateTimeInView:sender];
    
    [_storedValues setObject:@{@"slider":[NSNumber numberWithFloat:slider.value],
                                      @"progress":sender.timePosLabel.text,
                                      @"duration":sender.durationLabel.text}
                             forKey:sender.streamUrl.absoluteString];
}


- (NSString*)getStringFromTime:(double)time
{
    int secondsDuration = (int)time;
    int minutes = secondsDuration/60;
    int secondsLeft = secondsDuration%60;
    NSString *minutesString = [NSString stringWithFormat:@"%d", minutes];
    if (minutesString.length < 2) {
        minutesString = [NSString stringWithFormat:@"0%@", minutesString];
    }
    return [NSString stringWithFormat:@"%@:%02d", minutesString, secondsLeft];
}

#pragma mark - STKAudioPlayerDelegate
/// Raised when an item has started playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    
}

/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    
}

/// Raised when the state of the player has changed
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    switch (state) {
        case STKAudioPlayerStateReady:
        case STKAudioPlayerStatePaused:
        case STKAudioPlayerStateStopped:
        case STKAudioPlayerStateError:
        case STKAudioPlayerStateDisposed:
        {
            self.audioView.isPaused = YES;
        }
            break;
            
        case STKAudioPlayerStatePlaying:
        case STKAudioPlayerStateBuffering:
        {
            self.audioView.isPaused = NO;
        }
            break;
            
        default:
            break;
    }
}

/// Raised when an item has finished playing
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    [self.audioPlayer stop];
    _currentlyPlayingURL = nil;
}

/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    
}

//@optional
/// Optionally implemented to get logging information from the STKAudioPlayer (used internally for debugging)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer logInfo:(NSString*)line
{
    
}

/// Raised when items queued items are cleared (usually because of a call to play, setDataSource or stop)
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didCancelQueuedItems:(NSArray*)queuedItems
{
    
}

#pragma mark - Static helpers

+ (void)updateNowPlayingInfo:(NSString*)artist
{
    if (artist) {
        NSDictionary *nowPlaying = @{MPMediaItemPropertyArtist: [WSAudioFeedItemViewController applicationBundleDisplayName]
                                     ,MPMediaItemPropertyAlbumTitle: artist
                                     //,MPMediaItemPropertyPlaybackDuration: [NSNumber numberWithDouble:320.0]
                                     //,MPNowPlayingInfoPropertyPlaybackRate:@1.0f
                                     //, MPMediaItemPropertyArtwork:[songMedia valueForProperty:MPMediaItemPropertyArtwork]
                                     };
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlaying];
    }
}

+ (NSString*)applicationBundleDisplayName
{
    return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
