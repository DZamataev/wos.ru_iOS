//
//  WSViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 12/20/13.
//  Copyright (c) 2013 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayerView.h"
#import <AudioPlayer.h>

@interface WSViewController : UIViewController <AudioPlayerViewDelegate>
{
@private
	AudioPlayer* audioPlayer;
}
@end
