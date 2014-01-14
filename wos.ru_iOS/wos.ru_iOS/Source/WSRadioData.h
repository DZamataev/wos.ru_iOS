//
//  WSRStationsData.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSRStation;

@interface WSRadioData : NSObject
@property (nonatomic, strong) NSArray *stations; // objects of class WSRStation
@end
