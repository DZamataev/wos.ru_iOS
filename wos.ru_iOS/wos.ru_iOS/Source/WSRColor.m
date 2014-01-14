//
//  WSRColor.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSRColor.h"

@implementation WSRColor
- (UIColor *)UIColorFromComponents {
    return [UIColor colorWithRed:self.red.floatValue green:self.green.floatValue blue:self.blue.floatValue alpha:self.alpha.floatValue];
}
@end
