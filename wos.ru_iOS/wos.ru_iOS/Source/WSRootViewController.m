//
//  WSRootViewController.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSRootViewController.h"

#import "WSRadioViewController.h"

#import "WSWebBrowserViewController.h"

@interface WSRootViewController ()

@end

@implementation WSRootViewController {
    CGFloat _materialsContainerLeftOffsetConstraintDefaultValue;
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleOpenUrlNotification:)
                                                 name:@"WSOpenUrlNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSlideToFeedNotification:) name:@"WSSlideToFeed" object:nil];
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

+ (UIColor *)defaultAccentColor {
    return [[UIColor alloc] initWithRed:75.0f/255.0f green:133.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
}

- (void)handleOpenUrlNotification:(NSNotification*)notification
{
    NSURL *url = notification.userInfo[@"url"];
    if (url) {
        WSWebBrowserViewController *webBrowserController = [WSWebBrowserViewController webBrowserControllerWithDefaultNibAndHomeUrl:url];
        webBrowserController.cAttributes.isHidingBarsOnScrollingEnabled = NO;
        webBrowserController.cAttributes.isHttpAuthenticationPromptEnabled = NO;
        [CHWebBrowserViewController openWebBrowserController:webBrowserController modallyWithUrl:url animated:YES];
    }
}

- (void)handleSlideToFeedNotification:(NSNotification*)notification
{
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) animated:YES];
}

- (IBAction)showRadioToggle:(id)sender
{
    if (self.materialsContainerLeftOffsetConstraint.constant > 0) {
        _materialsContainerLeftOffsetConstraintDefaultValue = self.materialsContainerLeftOffsetConstraint.constant;
        self.materialsContainerLeftOffsetConstraint.constant = 0;
        [UIView animateWithDuration:0.5f animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }];
    }
    else {
        self.materialsContainerLeftOffsetConstraint.constant = _materialsContainerLeftOffsetConstraintDefaultValue;
        [UIView animateWithDuration:0.5f animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }];
    }
}
@end
