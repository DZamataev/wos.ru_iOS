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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAnotherAudioPlaybackInApplicationBecomesActiveNotification:)
                                                 name:@"WSAnotherAudioPlaybackInApplicationBecomesActive"
                                               object:nil];
}

- (void)dealloc
{
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

- (void)handleAnotherAudioPlaybackInApplicationBecomesActiveNotification:(NSNotification*)notification
{
    if (![notification.userInfo[@"source"] isEqualToString:@"feed"] ||
        ![notification.userInfo[@"streamUrlString"] isEqualToString:_currentlyPlayingURL.absoluteString]) {
        [self pauseInView:self.audioView];
    }
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSAnotherAudioPlaybackInApplicationBecomesActive"
                                                        object:nil
                                                      userInfo:@{@"source":@"feed",
                                                                 @"streamUrlString" : _currentlyPlayingURL.absoluteString}];
}

- (void)pauseInView:(WSAudioFeedItemView*)view
{
    [_audioPlayer pause];
    [view endUpdatingSlider];
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
