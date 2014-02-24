//
//  WSFeedGroup.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSFeedGroup : NSObject
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *userVisibleDate;
@property (strong, nonatomic) NSMutableArray *items;
@end
