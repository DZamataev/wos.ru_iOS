//
//  WSAudioFeedItemView.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/28/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSAudioFeedItemView.h"

@implementation WSAudioFeedItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isPaused = YES;
    }
    return self;
}

- (void)setIsPaused:(BOOL)isPaused
{
    _isPaused = isPaused;
    if (_isPaused) {
        [self.playButton setImage:[UIImage imageNamed:@"pausebutton"] forState:UIControlStateNormal];
    }
    else {
        [self.playButton setImage:[UIImage imageNamed:@"playbutton"] forState:UIControlStateNormal];
    }
}


- (IBAction)buttonTouched:(id)sender
{
    self.isPaused = !self.isPaused;
    
    if (_isPaused) {
        [self play];
    }
    else {
        [self pause];
    }
}

- (void)play
{
    self.playCallback();
}

- (void)pause
{
    self.pauseCallback();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
