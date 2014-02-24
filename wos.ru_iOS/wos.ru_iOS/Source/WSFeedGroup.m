//
//  WSFeedGroup.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSFeedGroup.h"

@implementation WSFeedGroup
- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray new];
    }
    return _items;
}
@end
