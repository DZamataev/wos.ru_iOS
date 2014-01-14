//
//  WSRadioMapper.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>

@interface WSRadioMapper : NSObject
+ (RKObjectMapping*)objectMappingForRadioData;
@end
