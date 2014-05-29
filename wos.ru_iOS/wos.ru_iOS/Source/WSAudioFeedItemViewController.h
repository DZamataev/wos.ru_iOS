//
//  WSAudioFeedItemViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/29/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVAsset.h>
#import "WSAudioFeedItemView.h"
#import "WSMaterial.h"

@interface WSAudioFeedItemViewController : UIViewController <WSAudioFeedItemViewDelegate>
{
    WSAudioFeedItemView *_currentlyPlayingAudioFeedItemView;
    NSURL *_currentlyPlayingURL;
}
@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) id playbackTimeObserver;
- (BOOL)isCurrentlyPlayingURL:(NSURL*)url;
@end
