//
//  WSAudioFeedItemView.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/28/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSAudioFeedItemView : UIView
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, copy) void (^playCallback)(void);
@property (nonatomic, copy) void (^pauseCallback)(void);
- (IBAction)buttonTouched:(id)sender;
@end
