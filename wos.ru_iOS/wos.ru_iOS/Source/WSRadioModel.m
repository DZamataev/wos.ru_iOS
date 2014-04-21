//
//  WSRadioModel.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSRadioModel.h"
#import "WSRadioData.h"
#import "WSRadioMapper.h"

NSString * const WSRawGithubRadioJSONPath = @"/DZamataev/wos.ru_iOS/master/radio.json";
NSString * const WSWWWDomain = @"http://w-o-s.ru";
NSString * const WSStreamsJSONPath = @"/api/streams";

@implementation WSRadioModel

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.rawGithubObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:WSWWWDomain]];
    [self.rawGithubObjectManager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];

    
    
    RKObjectMapping *radioMapping = [WSRadioMapper objectMappingForRadioData];
    
    RKResponseDescriptor *radioResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:radioMapping
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:WSStreamsJSONPath
                                                                                                keyPath:Nil
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self.rawGithubObjectManager addResponseDescriptor:radioResponseDescriptor];
}

- (void)loadRadioData:(void (^)(WSRadioData* data, NSError *error))completionBlock
{
    [self.rawGithubObjectManager getObjectsAtPath:WSStreamsJSONPath
                                       parameters:nil
                                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                              if (completionBlock) {
                                                  completionBlock(mappingResult.firstObject, nil);
                                              }
    }
                                          failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                              if (completionBlock) {
                                                  completionBlock(nil, error);
                                              }
    }];
}

@end
