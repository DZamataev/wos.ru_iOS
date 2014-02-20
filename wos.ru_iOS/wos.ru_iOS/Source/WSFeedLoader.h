//
//  WSFeedLoader.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKitSyndicate.h>

@class WSFeedItem;

@interface WSFeedLoader : NSObject
@property (strong, nonatomic) RKSFeedManager *feedManager;

- (void)loadFeedWithCompletionBlock:(void (^)(NSMutableArray *groups, NSError *error, BOOL isOld))completionBlock;
@end
