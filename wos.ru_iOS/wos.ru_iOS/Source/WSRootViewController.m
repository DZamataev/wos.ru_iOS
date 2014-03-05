//
//  WSRootViewController.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSRootViewController.h"

#import "WSRadioViewController.h"

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
//    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.scrollableContentWidthConstraint.constant = 640.0f;
//        [self.scrollView layoutIfNeeded];
//    } completion:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenUrlNotification:) name:@"WSOpenUrlNotification" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

+ (UIColor *)wosGrayColor {
    return [UIColor colorWithRed:(60.0/255.0) green:(60.0/255.0) blue:(60.0/255.0) alpha:(60.0/255.0)];
}

- (void)handleOpenUrlNotification:(NSNotification*)notification
{
    NSURL *url = notification.userInfo[@"url"];
    if (url) {
        CHWebBrowserViewController *webBrowserController = [CHWebBrowserViewController webBrowserControllerWithDefaultNib];
        webBrowserController.cAttributes.isHidingBarsOnScrollingEnabled = NO;
        webBrowserController.cAttributes.isHttpAuthenticationPromptEnabled = NO;
        [webBrowserController setOnDismissCallback:^(CHWebBrowserViewController *webBrowserVC) {
            for (id controller in self.childViewControllers) {
                if ([controller isKindOfClass:[WSRadioViewController class]]) {
                    [controller becomeFirstResponder];
                    break;
                }
            }
        }];
        [CHWebBrowserViewController openWebBrowserController:webBrowserController modallyWithUrl:url animated:YES];
    }
}
@end
