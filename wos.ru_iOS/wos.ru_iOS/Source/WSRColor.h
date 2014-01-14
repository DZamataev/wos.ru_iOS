//
//  WSRColor.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSRColor : NSObject
@property (strong, nonatomic) NSNumber *red;
@property (strong, nonatomic) NSNumber *green;
@property (strong, nonatomic) NSNumber *blue;
@property (strong, nonatomic) NSNumber *alpha;

- (UIColor*)UIColorFromComponents;
@end
