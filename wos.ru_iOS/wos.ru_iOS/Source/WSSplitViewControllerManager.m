//
//  WSMaterialsViewController.h
//  wos.ru_iOS
//
//  Created by Denis on 5/19/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSSplitViewControllerManager.h"
NSString * const WSSplitViewControllerManagerChangedMasterVisibilityNotification = @"WSSplitViewControllerManagerChangedMasterVisibilityNotification";

@implementation WSSplitViewControllerManager

+ (WSSplitViewControllerManager*)sharedInstance
{
    static WSSplitViewControllerManager* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[WSSplitViewControllerManager alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.isMasterHidden = NO;
    }
    return self;
}

- (void)setSplitViewController:(UISplitViewController *)splitViewController
{
    _splitViewController = splitViewController;
    _splitViewController.delegate = self;
}

- (UISplitViewController*)splitViewController
{
    return _splitViewController;
}

- (void)setIsMasterHidden:(BOOL)isMasterHidden
{
    BOOL shouldNotify = (_isMasterHidden != isMasterHidden);
    
    _isMasterHidden = isMasterHidden;
    [self.splitViewController.view setNeedsLayout];
    self.splitViewController.delegate = nil;
    self.splitViewController.delegate = self;
    
    [self.splitViewController willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];
    
    if (shouldNotify) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WSSplitViewControllerManagerChangedMasterVisibilityNotification
                                                            object:nil
                                                          userInfo:
         [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isMasterHidden]
                                     forKey:@"isMasterHidden"]];
    }
}

- (BOOL)isMasterHidden
{
    return _isMasterHidden;
}

// Returns YES if a view controller should be hidden by the split view controller in a given orientation.
// (This method is only called on the leftmost view controller and only discriminates portrait from landscape.)
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return self.isMasterHidden;
}
@end
