//
//  WSViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 12/20/13.
//  Copyright (c) 2013 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayerView.h"
#import <STKAudioPlayer.h>

@interface WSViewController : UIViewController <AudioPlayerViewDelegate>
{
@private
	STKAudioPlayer* audioPlayer;
}
@end
