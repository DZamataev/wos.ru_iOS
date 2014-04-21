//
//  WSMaterialsModel.m
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSMaterialsModel.h"
NSString *const WSBaseUrl = @"http://w-o-s.ru";

@implementation WSMaterialsModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
#if DEBUG
    // Log all HTTP traffic with request and response bodies
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    // Log debugging info about Core Data
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelDebug);
    
    // Log only critical messages from the Object Mapping component
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
#endif
    
    // Initialize RestKit
    self.objectManager = [WSMaterialsObjectManager managerWithBaseURL:[NSURL URLWithString:WSBaseUrl]];
    [self.objectManager setAcceptHeaderWithMIMEType:RKMIMETypeTextXML];
    
    // accept xml mime type and make parser add prefix _ before xml attributes
    [RKMIMETypeSerialization registerClass:[RKXMLDictionarySerialization class] forMIMEType:RKMIMETypeTextXML];
    [RKMIMETypeSerialization registerClass:[RKXMLDictionarySerialization class] forMIMEType:RKMIMETypeXML];
    [RKMIMETypeSerialization registerClass:[RKXMLDictionarySerialization class] forMIMEType:@"text/plain"];
    
    // add response descriptors
    
    RKResponseDescriptor *materialsResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self objectMappingForMaterialsCollection]
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/api/materials"
                                                keyPath:@"materials"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self.objectManager addResponseDescriptor:materialsResponseDescriptor];
   
}

- (RKObjectMapping*)objectMappingForMaterial
{
    RKObjectMapping *materialMapping = [RKObjectMapping mappingForClass:[WSMaterialsCollection class]];
    [materialMapping addAttributeMappingsFromDictionary:@{
                                                          @"date.__text" : @"date",
                                                          @"id.__text" : @"identifier",
                                                          @"type.__text" : @"typeStr",
                                                          @"subtype.__text" : @"subtypeStr",
                                                          @"title.__text" : @"title",
                                                          @"lead.__text" : @"lead",
                                                          @"picture.__text" : @"pictureStr",
                                                          @"url.__text" : @"urlStr",
                                                          @"show_count.__text" : @"showCountNum",
                                                          @"comments_count.__text" : @"commentsCountNum"
                                                          }];
    
    return materialMapping;

}

- (RKObjectMapping*)objectMappingForMaterialsCollection
{
    RKObjectMapping *materialsCollectionMapping = [RKObjectMapping mappingForClass:[WSMaterialsCollection class]];
    [materialsCollectionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"material"
                                                                                               toKeyPath:@"materials"
                                                                                             withMapping:[self objectMappingForMaterial]]];
    return materialsCollectionMapping;
}

#pragma mark - Loading actions

- (void)loadMaterialsWithCompletion:(void (^)(WSMaterialsCollection *materialsCollection, NSError *error))completionBlock
{
    [self.objectManager getObjectsAtPath:@"/api/materials"
                              parameters:nil
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     completionBlock(mappingResult.firstObject, nil);
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     completionBlock(nil, error);
                                 }];
}
@end
