//
//  WSMaterialsViewController.h
//  wos.ru_iOS
//
//  Created by Denis on 5/19/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const WSSplitViewControllerManagerChangedMasterVisibilityNotification;

@interface WSSplitViewControllerManager : NSObject <UISplitViewControllerDelegate>
{
    BOOL _isMasterHidden;
    UISplitViewController *_splitViewController;
}
@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, assign) BOOL isMasterHidden;
+ (WSSplitViewControllerManager*)sharedInstance;
@end
