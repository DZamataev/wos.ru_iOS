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
    if (![notification.userInfo[@"source"] isEqualToString:@"feed"])
        [self pause];
}

- (BOOL)isCurrentlyPlayingURL:(NSURL*)url
{
    NSString *urlStr = [url absoluteString];
    NSString *curUrlStr = [_currentlyPlayingURL absoluteString];
    return [urlStr isEqualToString:curUrlStr];
}

- (void)playInView:(WSAudioFeedItemView*)view fromTime:(CMTime)time
{
    if (!self.audioPlayer)
    {
        self.audioPlayer = [[AVPlayer alloc] init];
        CMTime interval = CMTimeMake(33, 1000);
        WSAudioFeedItemViewController __weak *weakSelf = self;
        self.playbackTimeObserver =
        [self.audioPlayer addPeriodicTimeObserverForInterval:interval
                                                       queue:nil
                                                  usingBlock: ^(CMTime time) {
                                                      if (weakSelf) {
                                                          [weakSelf updateTime:time];
                                                      }
                                                  }];
    }
    
    [_audioPlayer pause];
    _currentlyPlayingAudioFeedItemView.isPaused = YES;
    
    _currentlyPlayingURL = view.streamUrl;
    _currentlyPlayingAudioFeedItemView = view;
    
    _currentlyPlayingAudioFeedItemView.isPaused = NO;
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:view.streamUrl];
    view.durationLabel.text = [self getStringFromCMTime:asset.duration];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
    [_audioPlayer replaceCurrentItemWithPlayerItem:item];
    [_audioPlayer seekToTime:time];
    [_audioPlayer play];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSAnotherAudioPlaybackInApplicationBecomesActive"
                                                        object:nil
                                                      userInfo:@{@"source":@"feed"}];
}

- (void)pause
{
    _currentlyPlayingAudioFeedItemView.isPaused = YES;
    _currentlyPlayingURL = nil;
    _currentlyPlayingAudioFeedItemView = nil;
    [_audioPlayer pause];
}

- (void)updateTime:(CMTime)time
{
    CMTime endTime = CMTimeConvertScale (self.audioPlayer.currentItem.asset.duration, self.audioPlayer.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
    if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
        double normalizedTime = (double) self.audioPlayer.currentTime.value / (double) endTime.value;
        _currentlyPlayingAudioFeedItemView.progressBar.value = normalizedTime;
    }
    _currentlyPlayingAudioFeedItemView.timePosLabel.text = [self getStringFromCMTime:self.audioPlayer.currentTime];
}

- (CMTime)timeOnSlider:(UISlider*)slider inView:(WSAudioFeedItemView*)view
{
    AVURLAsset *asset = [AVURLAsset assetWithURL:view.streamUrl];
    CMTime seekTime = CMTimeMakeWithSeconds(
                                            slider.value * (double)asset.duration.value / (double)asset.duration.timescale,
                                            asset.duration.timescale
                                            );
    return seekTime;
}

-(BOOL)audioView:(id)sender shouldChangeToPaused:(BOOL)isPaused progressBar:(UISlider *)slider
{
    if (isPaused) {
        // should pause
        [self pause];
    }
    else {
        // should play
        [self playInView:sender fromTime:[self timeOnSlider:slider inView:sender]];
    }
    return YES;
}

-(void)audioView:(id)sender progressBarChanged:(UISlider *)slider
{
    if (sender == _currentlyPlayingAudioFeedItemView) {
        [self.audioPlayer pause];
        [self.audioPlayer seekToTime:[self timeOnSlider:slider inView:sender]];
    }
}

-(void)audioView:(id)sender proressBarChangeEnded:(UISlider *)slider
{
    if (sender == _currentlyPlayingAudioFeedItemView) {
        [self.audioPlayer play];
    }
    else {
        [self playInView:sender fromTime:[self timeOnSlider:slider inView:sender]];
    }
}

- (NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 duration = CMTimeGetSeconds(time);
    int secondsDuration = (int)duration;
    int minutes = secondsDuration/60;
    int secondsLeft = secondsDuration%60;
    NSString *minutesString = [NSString stringWithFormat:@"%d", minutes];
    if (minutesString.length < 2) {
        minutesString = [NSString stringWithFormat:@"0%@", minutesString];
    }
    return [NSString stringWithFormat:@"%@:%02d", minutesString, secondsLeft];
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
