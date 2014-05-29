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
        // Custom initialization
    }
    return self;
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

- (BOOL)isCurrentlyPlayingURL:(NSURL*)url
{
    NSString *urlStr = [url absoluteString];
    NSString *curUrlStr = [_currentlyPlayingURL absoluteString];
    return [urlStr isEqualToString:curUrlStr];
}

- (void)playInView:(WSAudioFeedItemView*)view fromTime:(CMTime)time
{
    if (!self.audioPlayer)
        self.audioPlayer = [[AVPlayer alloc] init];
    
    [_audioPlayer pause];
    _currentlyPlayingAudioFeedItemView.isPaused = YES;
    
    _currentlyPlayingURL = view.streamUrl;
    _currentlyPlayingAudioFeedItemView = view;
    
    _currentlyPlayingAudioFeedItemView.isPaused = NO;
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:view.streamUrl];
    Float64 duration = CMTimeGetSeconds(asset.duration);
    int secondsDuration = (int)duration;
    int minutes = secondsDuration/60;
    int secondsLeft = secondsDuration%60;
    view.durationLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, secondsLeft];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
    [_audioPlayer replaceCurrentItemWithPlayerItem:item];
    [_audioPlayer seekToTime:time];
    [_audioPlayer play];
}

- (void)pause
{
    _currentlyPlayingURL = nil;
    _currentlyPlayingAudioFeedItemView = nil;
    [_audioPlayer pause];
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
    if (_currentlyPlayingURL) {
        [self.audioPlayer pause];
    }
    [self.audioPlayer seekToTime:[self timeOnSlider:slider inView:sender]];
}

-(void)audioView:(id)sender proressBarChangeEnded:(UISlider *)slider
{
    if (_currentlyPlayingURL) {
        [self.audioPlayer play];
    }
    else {
        [self playInView:sender fromTime:[self timeOnSlider:slider inView:sender]];
    }
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
