//
//  WSMaterialsModel.h
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>
#import <RKXMLDictionarySerialization.h>

#import "WSMaterialsCollection.h"
#import "WSMaterial.h"
#import "WSMaterialsObjectManager.h"

FOUNDATION_EXPORT NSString *const WSGithubBaseUrl;
FOUNDATION_EXPORT NSString *const WSGithubMaterialsPath;

FOUNDATION_EXPORT NSString *const WSBaseUrl;
FOUNDATION_EXPORT NSString *const WSMaterialsPath;

@interface WSMaterialsModel : NSObject

- (void)configure;
- (void)loadMaterialsWithCompletion:(void (^)(WSMaterialsCollection *materialsCollection, NSError *error))completionBlock;
@property WSMaterialsObjectManager *objectManager;
@property WSMaterialsCollection *materialsCollection;
@end
