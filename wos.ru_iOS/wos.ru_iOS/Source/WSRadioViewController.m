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

#import "WSVolumeSlider.h"
#import "WSPlayButton.h"


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
	// Do any additional setup after loading the view.
    _radioModel = [[WSRadioModel alloc] init];
    [_radioModel loadRadioData:^(WSRadioData *data, NSError *error) {
        NSLog(@"%@ %@", data, data.stations);
        
    }];
    self.accentColor = WSRadioViewControllerInitialAccentColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Properties

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
@end
