//
//  WSFeedItem.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSFeedItem : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *snippet;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *visibleDate;
@property (strong, nonatomic) NSURL *linkUrl;
@end
