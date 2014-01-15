//
//  WSPlayButtonDelegate.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/15/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSPlayButton;

@protocol WSPlayButtonDelegate <NSObject>

- (BOOL)playButtonShouldPlay:(WSPlayButton*)playButton;
- (BOOL)playButtonShouldPause:(WSPlayButton*)playButton;

@end

