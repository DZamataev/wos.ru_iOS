//
//  WSFeedLoader.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSFeedLoader.h"
#import "WSFeedItem.h"

@implementation WSFeedLoader
- (id)init {
    self = [super init];
    if (self) {
        self.feedManager = [[RKSFeedManager alloc] initWithUrl:[NSURL URLWithString:@"http://w-o-s.ru"] andStoreName:@"w-o-s_feed.sqlite"];
    }
    return self;
}

- (void)loadFeedWithCompletionBlock:(void (^)(NSMutableArray *groups, NSError *error, BOOL isOld))completionBlock {
    [self.feedManager loadFeedAtPath:@"/rss" ofType:RKSFeedTypeRSS20
                     withRootKeyPath:@"rss" andParameters:nil
                  andCompletionBlock:^(RKSFeed *feed, NSError *error, BOOL isOld) {
                      NSMutableArray *groups = [NSMutableArray new];
                      NSMutableArray *group = [NSMutableArray new];
                      NSDate *dateCoursor = nil;
                      
                      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                      [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
                      [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
                      
                      NSDateFormatter *userVisibleDateFormatter = [[NSDateFormatter alloc] init];
                      
                      [userVisibleDateFormatter setDateStyle:NSDateFormatterShortStyle];
                      [userVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
                      
                      
                      if (feed.channels.count > 0) {
                          RKSChannel *channel = feed.channels.firstObject;
                          for (RKSItem *modelItem in channel.items) {
                              
                              NSDate *date = [dateFormatter dateFromString:modelItem.pubDate];
                              NSString *userVisibleDateTimeString = [userVisibleDateFormatter stringFromDate:date];
                              WSFeedItem *viewItem = [WSFeedItem new];
                              
                              NSLog(@"parsed date string %@ to date %@ redable date %@", modelItem.pubDate, date, userVisibleDateTimeString);
                          }
                      }
                      
                      completionBlock(groups, error, isOld);
                  }];
}
@end
