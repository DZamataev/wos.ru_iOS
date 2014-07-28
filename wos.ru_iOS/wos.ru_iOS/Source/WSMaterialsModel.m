//
//  WSMaterialsModel.m
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSMaterialsModel.h"

NSString *const WSGithubBaseUrl = @"https://raw.githubusercontent.com";
NSString *const WSGithubMaterialsPath = @"/DZamataev/wos.ru_iOS/master/materials.xml";

NSString *const WSBaseUrl = @"http://w-o-s.ru";
NSString *const WSMaterialsPath = @"/api/materials";

NSString *const WSSeenMaterialsFileName = @"WSSeenMaterials";

@implementation WSMaterialsModel
{
    NSMutableArray *_seenMaterials;
    NSInteger _seenMaterialsLimit;
}


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
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    // Log debugging info about Core Data
//    RKLogConfigureByName("RestKit/CoreData", RKLogLevelDebug);
    
    // Log only critical messages from the Object Mapping component
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
#endif
    
    // Initialize RestKit
    self.objectManager = [WSMaterialsObjectManager managerWithBaseURL:[NSURL URLWithString:WSBaseUrl]];
    [self.objectManager setAcceptHeaderWithMIMEType:RKMIMETypeTextXML];
    
    // accept xml mime type and make parser add prefix _ before xml attributes
    [RKMIMETypeSerialization registerClass:[RKXMLDictionarySerialization class] forMIMEType:RKMIMETypeTextXML];
    [RKMIMETypeSerialization registerClass:[RKXMLDictionarySerialization class] forMIMEType:RKMIMETypeXML];
//    [RKMIMETypeSerialization registerClass:[RKXMLDictionarySerialization class] forMIMEType:@"text/plain"];
    
    // add response descriptors
    
    RKResponseDescriptor *materialsResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[self objectMappingForMaterialsCollection]
                                                 method:RKRequestMethodGET
                                            pathPattern:WSMaterialsPath
                                                keyPath:@"materials"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self.objectManager addResponseDescriptor:materialsResponseDescriptor];
   
    
    // Load seen materials from user defaults
    _seenMaterials = [NSMutableArray wa_loadFromDiskOrInstantiateNewWithFileName:WSSeenMaterialsFileName];
    _seenMaterialsLimit = 3000;
}

- (RKObjectMapping*)objectMappingForMaterial
{
    RKObjectMapping *materialMapping = [RKObjectMapping mappingForClass:[WSMaterial class]];
    [materialMapping addAttributeMappingsFromDictionary:@{
                                                          @"date.__text" : @"dateStr",
                                                          @"id.__text" : @"identifier",
                                                          @"type.__text" : @"typeStr",
                                                          @"subtype.__text" : @"subtypeStr",
                                                          @"title.__text" : @"title",
                                                          @"lead.__text" : @"lead",
                                                          @"picture.__text" : @"pictureStr",
                                                          @"url.__text" : @"urlStr",
                                                          @"mp3_url.__text" : @"mp3UrlStr",
                                                          @"show_count.__text" : @"showCountNum",
                                                          @"comments_count.__text" : @"commentsCountNum",
                                                          @"best.__text" : @"bestStr"
                                                          }];
    [materialMapping addAttributeMappingsFromDictionary:@{@"date.__text" : @"date"}];
    
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

#pragma mark - Public

-(void)markMaterialAsSeenWithIdentifier:(NSNumber *)identifier
{
    if (identifier)
    {
        [_seenMaterials addObject:identifier];
        if (_seenMaterials.count > _seenMaterialsLimit) {
            [_seenMaterials removeObject:_seenMaterials.firstObject];
        }
        [_seenMaterials wa_saveOnDiskWithFileName:WSSeenMaterialsFileName];
    }
}

- (void)loadMaterialsWithCompletion:(void (^)(WSMaterialsCollection *materialsCollection, NSError *error))completionBlock
{
    [self.objectManager getObjectsAtPath:WSMaterialsPath
                              parameters:nil
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     self.materialsCollection = mappingResult.firstObject;
                                     [self.materialsCollection processMaterialsWithSeen:_seenMaterials];
                                     // Analytics
                                     [PFAnalytics trackEvent:@"materials loaded successfully"
                                                  dimensions:@{@"all materials count":@(self.materialsCollection.materials.count).stringValue,
                                                               @"best materials count":@(self.materialsCollection.bestMaterials.count).stringValue,
                                                               @"micro materials count":@(self.materialsCollection.microMaterials.count).stringValue,
                                                               @"other materials count":@(self.materialsCollection.otherMaterials.count).stringValue,
                                                               @"seen materials count":@(_seenMaterials.count).stringValue}];
                                     //
                                     completionBlock(self.materialsCollection, nil);
                                 }
                                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     // Analytics
                                     [PFAnalytics trackEvent:@"error loading materials"
                                                  dimensions:@{@"error description":error.description}];
                                     //
                                     completionBlock(nil, error);
                                 }];
    
    
}
@end
