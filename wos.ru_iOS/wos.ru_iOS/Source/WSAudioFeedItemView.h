//
//  WSAudioFeedItemView.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/28/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSAudioFeedItemViewDelegate <NSObject>
-(void)audioView:(id)sender progressBarChanged:(UISlider*)slider;
-(void)audioView:(id)sender proressBarChangeEnded:(UISlider*)slider;
-(BOOL)audioView:(id)sender shouldChangeToPaused:(BOOL)isPaused progressBar:(UISlider*)slider;
@end

@interface WSAudioFeedItemView : UIView
@property (nonatomic, strong) NSURL *streamUrl;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UILabel *timePosLabel;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;
@property (nonatomic, strong) IBOutlet UISlider *progressBar;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, assign) id <WSAudioFeedItemViewDelegate> delegate;
- (IBAction)buttonTouched:(id)sender;
@end


