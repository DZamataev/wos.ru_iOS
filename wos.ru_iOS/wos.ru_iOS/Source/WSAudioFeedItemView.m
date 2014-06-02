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
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)commonInit
{
    self.isPaused = YES;
    [self.progressBar addTarget:self action:@selector(progressBarChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressBar addTarget:self action:@selector(proressBarChangeEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)]];
    
    
    // color the progressBar UISlider
    // thumb image
    UIImage* thumbImage = [[WSAudioFeedItemView imageWithColor:[UIColor clearColor] ofSize:CGSizeMake(10, self.frame.size.height)] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.progressBar setThumbImage:thumbImage forState:UIControlStateNormal];

    // min track image
    UIImage *minTrackImg = [[WSAudioFeedItemView imageWithColor:self.progressBar.minimumTrackTintColor ofSize:CGSizeMake(10, self.frame.size.height)] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.progressBar setMinimumTrackImage:minTrackImg forState:UIControlStateNormal];
    
    // max track image
    UIImage *maxTrackImg = [[WSAudioFeedItemView imageWithColor:[UIColor clearColor] ofSize:CGSizeMake(10, self.frame.size.height)] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.progressBar setMaximumTrackImage:maxTrackImg forState:UIControlStateNormal];
    
}

- (void)dealloc
{
}

- (void)setIsPaused:(BOOL)isPaused
{
    BOOL changed = _isPaused != isPaused;
    _isPaused = isPaused;
    if (changed) {
        if (_isPaused) {
            [self.playButton setImage:[UIImage imageNamed:@"playbutton"] forState:UIControlStateNormal];
        }
        else {
            [self.playButton setImage:[UIImage imageNamed:@"pausebutton"] forState:UIControlStateNormal];
        }
    }
}

- (void)startUpdatingSlider
{
    self.sliderUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(updateSlider)
                                                            userInfo:nil
                                                             repeats:YES];
}

- (void)endUpdatingSlider
{
    [self.sliderUpdateTimer invalidate];
    self.sliderUpdateTimer = nil;
}

- (void)updateSlider
{
    [self.delegate audioView:self progressBarUpdateTick:self.progressBar];
}

- (IBAction)buttonTouched:(id)sender
{
    BOOL newPausedValue = !self.isPaused;
    BOOL shouldChange = [self.delegate audioView:self shouldChangeToPaused:newPausedValue progressBar:self.progressBar];
    
    if (shouldChange) {
        self.isPaused = newPausedValue;
    }
}

- (void)sliderTapped:(UIGestureRecognizer *)g {
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return; // tap on thumb, let slider deal with it
    CGPoint pt = [g locationInView: s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    
    [self.delegate audioView:self progressBarChanged:self.progressBar];
    [self.delegate audioView:self proressBarChangeEnded:self.progressBar];
}

-(void)progressBarChanged:(UISlider*)sender
{
    [self.delegate audioView:self progressBarChanged:sender];
}

-(void)proressBarChangeEnded:(UISlider*)sender
{
    [self.delegate audioView:self proressBarChangeEnded:sender];
}

+ (UIImage *)imageWithColor:(UIColor *)color ofSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeNormal);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    return result;
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
