//
//  WSFeedTableViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSFeedCell, WSFeedHeaderCell;
@class WSFeedItem, WSFeedLoader;

@interface WSFeedTableViewController : UITableViewController
{
    NSMutableArray *_objects; // arrays with objects of class WSFeedItem
}
@property (strong, nonatomic) WSFeedLoader *feedLoader;
@end
