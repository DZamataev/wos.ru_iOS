//
//  WSVolumeSlider.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/10/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WSVolumeSliderInitialAccentColor ([[UIColor alloc] initWithRed:240.0f/255.0f green:92.0f/255.0f blue:77.0f/255.0f alpha:1.0f])

@interface WSVolumeSlider : UISlider
{
    UIColor *_accentColor;
}

@property (strong, nonatomic) IBOutlet UIColor *accentColor;
@end
