//
//  WSSleepTimerPickerViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/17/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WSSleepTimerPickerDelegate.h"

@interface WSSleepTimerPickerViewController : UITableViewController
@property (assign, nonatomic) IBOutlet id<WSSleepTimerPickerDelegate> delegate;
- (IBAction)selectActualItem:(id)sender;
@end
