//
//  WSRStation.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSRColor;
@class WSRStream;

@interface WSRStation : NSObject
@property (strong, nonatomic) NSArray *streams; // objects of class WSRStream
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) WSRColor *color;
@end
