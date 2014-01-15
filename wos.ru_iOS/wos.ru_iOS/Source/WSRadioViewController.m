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
        }
    }];
    self.accentColor = WSRadioViewControllerInitialAccentColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Properties

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
        }
    }];
}


- (void)selectedRadiostationAtIndex:(NSInteger)index andPlayIt:(BOOL)shouldPlay
{
    if (index != NSNotFound && _stations.count > index) {
        WSRStation *station = _stations[index];
        
        self.accentColor = station.color.UIColorFromComponents;
        
        [self findStreamForRadiostation:station andPlayIt:shouldPlay];
    }
}

- (void)findStreamForRadiostation:(WSRStation*)station andPlayIt:(BOOL)shouldPlay
{
    // lets pick bitrate from available streams for this radiostation
    for (WSRStream *stream in station.streams) {
        // ok 192 is the best for now
        if (stream.bitrate.integerValue == 192) {
            NSURL* url = stream.url;
            [self.audioPlayer play:url];
            if (shouldPlay) {
                self.playButton.isPaused = NO; // force change the button state
            }
            else {
                [self performSelector:@selector(pauseAudioPlayer) withObject:Nil afterDelay:0.1f];
            }
        }
    }
}

- (void)pauseAudioPlayer {
    [self.audioPlayer pause];
    self.playButton.isPaused = YES; // force change the button state
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

@end
