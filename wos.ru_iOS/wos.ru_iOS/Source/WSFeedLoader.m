//
//  WSFeedLoader.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSFeedLoader.h"
#import "WSFeedItem.h"
#import "WSFeedGroup.h"

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
                      WSFeedGroup *group = [WSFeedGroup new];
                      [groups addObject:group];
                      NSDate *dayCoursor = nil;
                      NSCalendar *cal = [NSCalendar currentCalendar];
                      
                      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                      [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
                      [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
                      
                      NSDateFormatter *userVisibleDateFormatter = [[NSDateFormatter alloc] init];
                      [userVisibleDateFormatter setDateFormat:@"eeee dd MMMM"];
                      
                      if (feed.channels.count > 0) {
                          RKSChannel *channel = feed.channels.firstObject;
                          for (RKSItem *modelItem in channel.items) {
                              
                              NSDate *date = [dateFormatter dateFromString:modelItem.pubDate];
                              NSString *userVisibleDateTimeString = [userVisibleDateFormatter stringFromDate:date];
                              
                              WSFeedItem *viewItem = [WSFeedItem new];
                              UIView *view = [UIView new];
                              [view setExclusiveTouch:YES];
                              // place item into group. Groups are made by days.
                              if (date) {
                                  if (!dayCoursor) dayCoursor = date;
                                  if (!group.date) group.date = date;
                                  if (!group.userVisibleDate) group.userVisibleDate = userVisibleDateTimeString;
                                  
                                  NSDateComponents *comps1 = [cal components:(NSMonthCalendarUnit| NSYearCalendarUnit | NSDayCalendarUnit)
                                                                    fromDate:date];
                                  NSDateComponents *comps2 = [cal components:(NSMonthCalendarUnit| NSYearCalendarUnit | NSDayCalendarUnit)
                                                                    fromDate:dayCoursor];
                                  BOOL sameDay = ([comps1 day] == [comps2 day]
                                                  && [comps1 month] == [comps2 month]
                                                  && [comps1 year] == [comps2 year]);
                                  if (sameDay) {
                                  }
                                  else {
                                      dayCoursor = date;
                                      
                                      group = [WSFeedGroup new];
                                      [groups addObject:group];
                                  }
                              }
                              viewItem.title = modelItem.title;
                              
                              NSString *snippetStr = modelItem.descriptionAttribute ? modelItem.descriptionAttribute : @"";
                              
                              // detect image url inside description
                              NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
                              
                              [detector enumerateMatchesInString:snippetStr
                                                         options:kNilOptions
                                                           range:NSMakeRange(0, [snippetStr length])
                                                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                                          viewItem.imageUrl = result.URL;
                                                      }];
                              // strip image tag from description
                              NSString *HTMLTagsRegex = @"<[^>]*>"; //regex to remove any html tag
                              NSString *snippetWithoutHTML = [snippetStr stringByReplacingOccurrencesOfRegex:HTMLTagsRegex withString:@""];
                              viewItem.snippet = snippetWithoutHTML;
                              
                              viewItem.visibleDate = userVisibleDateTimeString;
                              viewItem.linkUrl = [NSURL URLWithString:modelItem.link];
                              
                              [group.items addObject:viewItem];
//                              NSLog(@"parsed date string %@ to date %@ readable date %@", modelItem.pubDate, date, userVisibleDateTimeString);
                          }
                      }
                      
                      completionBlock(groups, error, isOld);
                  }];
}
@end
