//
//  WSRootViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSRadioViewController;
@class WSWebBrowserViewController;

@interface WSRootViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollableContentWidthConstraint;

+ (UIColor*)wosGrayColor;
+ (UIColor*)defaultAccentColor;
@end
