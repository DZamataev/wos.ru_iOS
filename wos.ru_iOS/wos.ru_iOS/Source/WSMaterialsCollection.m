//
//  WSMaterialsCollection.m
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSMaterialsCollection.h"
#import "WSMaterial.h"

@implementation WSMaterialsCollection
- (void)processMaterialsWithSeen:(NSArray *)seenArray
{
    self.bestMaterials = [NSMutableArray new];
    self.microMaterials = [NSMutableArray new];
    self.otherMaterials = [NSMutableArray new];
    
    for (WSMaterial *mat in self.materials) {
        [seenArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *seenId = obj;
            NSNumber *matId = mat.identifier;
            if (seenId.integerValue == matId.integerValue) {
                mat.isSeen = YES;
            }
        }];
        
        if ([mat.bestStr isEqualToString:@"true"]) {
            [self.bestMaterials addObject:mat];
        }
        if ([mat.subtypeStr isEqualToString:@"micro"]) {
            [self.microMaterials addObject:mat];
        }
        else {
            [self.otherMaterials addObject:mat];
        }
        
    }
}
@end
