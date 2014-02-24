//
//  WSRootViewController.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSRootViewController.h"

@interface WSRootViewController ()

@end

@implementation WSRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.scrollableContentWidthConstraint.constant = 640.0f;
        [self.scrollView layoutIfNeeded];
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

+ (UIColor *)wosGrayColor {
    return [UIColor colorWithRed:(60.0/255.0) green:(60.0/255.0) blue:(60.0/255.0) alpha:(60.0/255.0)];
}
@end
