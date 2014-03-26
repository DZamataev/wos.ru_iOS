//
//  WSWebBrowserViewController.m
//  wos.ru_iOS
//
//  Created by Denis on 3/27/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSWebBrowserViewController.h"

@interface WSWebBrowserViewController ()

@end

@implementation WSWebBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self becomeFirstResponder];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSRemoteControlRecevedWithEventNotification"
                                                        object:nil
                                                      userInfo:@{ @"event" : event }];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

+ (id)webBrowserControllerWithDefaultNibAndHomeUrl:(NSURL*)url
{
    WSWebBrowserViewController *webBrowserController = [[WSWebBrowserViewController alloc] initWithNibName:[WSWebBrowserViewController defaultNibFileName]
                                                                                                    bundle:nil];
    webBrowserController.homeUrl = url;
    return webBrowserController;
}

+ (NSString*)defaultNibFileName {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"WSWebBrowserViewController_iPad";
    }
    else {
        return @"WSWebBrowserViewController_iPhone";
    }
}

@end
