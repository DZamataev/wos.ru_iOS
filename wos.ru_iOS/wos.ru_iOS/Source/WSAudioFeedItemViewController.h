//
//  WSAudioFeedItemViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/29/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STKAudioPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "WSAudioFeedItemView.h"
#import "WSMaterial.h"

@interface WSAudioFeedItemViewController : UIViewController <WSAudioFeedItemViewDelegate, STKAudioPlayerDelegate>
{
    NSURL *_currentlyPlayingURL;
    NSMutableDictionary *_storedValues;
}
@property (nonatomic, strong) STKAudioPlayer *audioPlayer;
@property (nonatomic, strong) WSAudioFeedItemView *audioView;
@property (nonatomic, strong) NSString *artistInfo;
@property (nonatomic, assign) BOOL ignoreRemoteControlEvents;
- (void)configureView:(WSAudioFeedItemView*)view withStreamUrl:(NSURL*)streamUrl;
- (void)prepareViewForReuse:(WSAudioFeedItemView*)view;
@end
