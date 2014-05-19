//
//  WSMaterialsViewController.m
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSMaterialsViewController.h"

@interface WSMaterialsViewController ()

@end

@implementation WSMaterialsViewController

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
    [[WSSplitViewControllerManager sharedInstance] setSplitViewController:self.splitViewController];
    // Do any additional setup after loading the view.
    if (self.splitViewController) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleOpenUrlNotification:)
                                                     name:@"WSOpenUrlNotification"
                                                   object:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WSOpenUrlNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealUnderLeft:(id)sender
{
    [[WSSplitViewControllerManager sharedInstance] setIsMasterHidden:![WSSplitViewControllerManager sharedInstance].isMasterHidden];
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

@end
