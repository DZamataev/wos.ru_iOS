//
//  WSFeedTableViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@class WSFeedItemView, WSFeedHeaderView;
@class WSFeedItem, WSFeedGroup, WSFeedLoader;

@interface WSFeedTableViewController : UITableViewController
{
    NSMutableArray *_objects; // arrays with objects of class WSFeedGroup
    UIImage *_placeholderImage;
    
    IBOutlet UIView *_dummiesContainer;
    WSFeedItemView *_dummyFeedItemView;
}
@property (strong, nonatomic) WSFeedLoader *feedLoader;
@end
