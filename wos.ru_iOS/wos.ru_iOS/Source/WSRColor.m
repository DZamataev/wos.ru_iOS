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
    return [UIColor colorWithRed:self.red.floatValue/255 green:self.green.floatValue/255 blue:self.blue.floatValue/255 alpha:self.alpha.floatValue];
}
@end
