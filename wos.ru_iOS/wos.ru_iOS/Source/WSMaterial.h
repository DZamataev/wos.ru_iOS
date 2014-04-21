//
//  WSMaterial.h
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//
/* 
 xml entity example:
<material>
<date>1398081600</date>
<id>8527</id>
<type>news</type>
<subtype>article</subtype>
<title>Михаил Идов покинул пост главного редактора GQ</title>
<lead>Модный журнал остался без иконы стиля</lead>
<picture>http://w-o-s.ru/upload/2014/April/21_Monday/62b18df7d6e50321f4d0340cee38c5cf.jpg</picture>
<url>http://w-o-s.ru/news/8527</url>
<show_count>83</show_count>
<comments_count>0</comments_count>
</material>
 */

#import <Foundation/Foundation.h>

@interface WSMaterial : NSObject
@property NSDate *date;
@property NSString *dateStr;
@property NSNumber *identifier;
@property NSString *typeStr;
@property NSString *subtypeStr;
@property NSString *title;
@property NSString *lead;
@property NSString *pictureStr;
@property NSString *urlStr;
@property NSString *bestStr;
@property NSNumber *showCountNum;
@property NSNumber *commentsCountNum;
@end
