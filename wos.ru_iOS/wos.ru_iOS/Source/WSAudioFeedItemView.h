//
//  WSAudioFeedItemView.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/28/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSAudioFeedItemView;

@protocol WSAudioFeedItemViewDelegate <NSObject>
-(void)audioView:(WSAudioFeedItemView*)sender progressBarChanged:(UISlider*)slider;
-(void)audioView:(WSAudioFeedItemView*)sender proressBarChangeEnded:(UISlider*)slider;
-(void)audioView:(WSAudioFeedItemView*)sender progressBarUpdateTick:(UISlider*)slider;
-(BOOL)audioView:(WSAudioFeedItemView*)sender shouldChangeToPaused:(BOOL)isPaused progressBar:(UISlider*)slider;
@end

@interface WSAudioFeedItemView : UIView
@property (nonatomic, strong) NSURL *streamUrl;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UILabel *timePosLabel;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;
@property (nonatomic, strong) IBOutlet UISlider *progressBar;
@property (nonatomic, strong) NSTimer *sliderUpdateTimer;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, assign) id <WSAudioFeedItemViewDelegate> delegate;
- (IBAction)buttonTouched:(id)sender;
- (void)startUpdatingSlider;
- (void)endUpdatingSlider;
@end


