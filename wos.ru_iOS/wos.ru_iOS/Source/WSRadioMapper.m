//
//  WSRadioMapper.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSRadioMapper.h"
#import "WSRadioData.h"
#import "WSRStation.h"
#import "WSRStream.h"
#import "WSRColor.h"

@implementation WSRadioMapper
+ (RKObjectMapping*)objectMappingForRadioData
{
    RKObjectMapping *colorMapping = [RKObjectMapping mappingForClass:[WSRColor class]];
    [colorMapping addAttributeMappingsFromDictionary:@{ @"r": @"red", @"g": @"green", @"b": @"blue", @"a" : @"alpha" }];
    
    RKObjectMapping *streamMapping = [RKObjectMapping mappingForClass:[WSRStream class]];
    [streamMapping addAttributeMappingsFromArray:@[ @"bitrate", @"url" ]];
    
    RKObjectMapping *stationMapping = [RKObjectMapping mappingForClass:[WSRStation class]];
    [stationMapping addAttributeMappingsFromArray:@[ @"name" ]];
    [stationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"streams" toKeyPath:@"streams" withMapping:streamMapping]];
    [stationMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"color" toKeyPath:@"color" withMapping:colorMapping]];
    
    RKObjectMapping *radioDataMapping = [RKObjectMapping mappingForClass:[WSRadioData class]];
    [radioDataMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"radiostations" toKeyPath:@"stations" withMapping:stationMapping]];
    
    return radioDataMapping;
}
@end
