//
//  WSViewController.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 12/20/13.
//  Copyright (c) 2013 DZamataev. All rights reserved.
//

#import "WSViewController.h"

@interface WSViewController ()

@end

@implementation WSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    audioPlayer = [[AudioPlayer alloc] init];
	AudioPlayerView* audioPlayerView = [[AudioPlayerView alloc] initWithFrame:self.view.frame];
    
	audioPlayerView.delegate = self;
	audioPlayerView.audioPlayer = audioPlayer;
	
	[self.view addSubview:audioPlayerView];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) audioPlayerViewPlayFromHTTPSelected:(AudioPlayerView*)audioPlayerView
{
	NSURL* url = [NSURL URLWithString:@"http://archstreet.cc:8000/blue-live192"];
    
	[audioPlayer setDataSource:[audioPlayer dataSourceFromURL:url] withQueueItemId:url];
}

-(void) audioPlayerViewPlayFromLocalFileSelected:(AudioPlayerView*)audioPlayerView
{
	NSString * path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"m4a"];
	NSURL* url = [NSURL fileURLWithPath:path];
	
	[audioPlayer setDataSource:[audioPlayer dataSourceFromURL:url] withQueueItemId:url];
}


@end
