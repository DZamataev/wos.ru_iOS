//
//  WSSleepTimerPickerDelegate.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/17/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSSleepTimerPickerViewController;

@protocol WSSleepTimerPickerDelegate <NSObject>
- (void)sleepTimerPickerViewController:(WSSleepTimerPickerViewController*)pickerController pickedTimeInterval:(NSNumber*)timeInterval;
@end
