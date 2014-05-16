//
//  WSAutoScrollLabel.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/16/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "CBAutoScrollLabel.h"

@class WSCopyableAutoScrollLabel;

@protocol WSCopyableLabelDelegate <NSObject>

@optional
- (NSString *)stringToCopyForCopyableLabel:(WSCopyableAutoScrollLabel *)copyableLabel;
- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(WSCopyableAutoScrollLabel *)copyableLabel;

@end

@interface WSCopyableAutoScrollLabel : CBAutoScrollLabel
@property (nonatomic, assign) BOOL copyingEnabled; // Defaults to YES

@property (nonatomic, weak) id<WSCopyableLabelDelegate> copyableLabelDelegate;

@property (nonatomic, assign) UIMenuControllerArrowDirection copyMenuArrowDirection; // Defaults to UIMenuControllerArrowDefault

// You may want to add longPressGestureRecognizer to a container view
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end
