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
        [self pauseInView:nil];
    }
}

- (void)configureView:(WSAudioFeedItemView*)view withStreamUrl:(NSURL*)streamUrl
{
    view.delegate = self;
    view.streamUrl = streamUrl;
    
    view.isPaused =  self.audioPlayer.state != STKAudioPlayerStatePlaying;
    
    if (view.isPaused) {
        [view endUpdatingSlider];
    }
    else {
        [view startUpdatingSlider];
    }
    
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

- (void)playInView:(WSAudioFeedItemView*)view
{
    if (!self.audioPlayer)
    {
        self.audioPlayer = [[STKAudioPlayer alloc] init];
    }
    
    if (!_currentlyPlayingURL) {
        _currentlyPlayingURL = view.streamUrl;
        [self.audioPlayer playURL:_currentlyPlayingURL];
    }
    else {
        [self.audioPlayer resume];
    }
    
    [view startUpdatingSlider];
    view.isPaused = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSAnotherAudioPlaybackInApplicationBecomesActive"
                                                        object:nil
                                                      userInfo:@{@"source":@"feed",
                                                                 @"streamUrlString" : _currentlyPlayingURL.absoluteString}];
}

- (void)pauseInView:(WSAudioFeedItemView*)view
{
    [_audioPlayer pause];
    [view endUpdatingSlider];
    view.isPaused = YES;
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
    }
    
    [self updateTimeInView:sender];
    
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
