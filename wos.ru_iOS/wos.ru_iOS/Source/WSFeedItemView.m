//
//  WSFeedCell.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSFeedItemView.h"

@implementation WSFeedItemView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.backgroundColor = [UIColor darkGrayColor];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
