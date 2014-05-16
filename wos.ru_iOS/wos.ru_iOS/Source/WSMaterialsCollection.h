//
//  WSMaterialsCollection.h
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSMaterial;

@interface WSMaterialsCollection : NSObject
@property NSMutableArray *materials;
@property NSMutableArray *bestMaterials;
@property NSMutableArray *microMaterials;
@property NSMutableArray *otherMaterials;
- (void)processMaterialsWithSeen:(NSArray*)seenArray;
@end
