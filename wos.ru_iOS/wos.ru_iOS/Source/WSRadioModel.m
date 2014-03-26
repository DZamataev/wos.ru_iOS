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

@implementation WSRadioModel

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.rawGithubObjectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://raw.github.com"]];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];

    
    
    RKObjectMapping *radioMapping = [WSRadioMapper objectMappingForRadioData];
    
    RKResponseDescriptor *radioResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:radioMapping
                                                                                                 method:RKRequestMethodGET
                                                                                            pathPattern:WSRawGithubRadioJSONPath
                                                                                                keyPath:Nil
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self.rawGithubObjectManager addResponseDescriptor:radioResponseDescriptor];
}

- (void)loadRadioData:(void (^)(WSRadioData* data, NSError *error))completionBlock
{
    [self.rawGithubObjectManager getObjectsAtPath:WSRawGithubRadioJSONPath
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
