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
- (void)processMaterials
{
    self.bestMaterials = [NSMutableArray new];
    self.microMaterials = [NSMutableArray new];
    self.otherMaterials = [NSMutableArray new];
    
    for (WSMaterial *mat in self.materials) {
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
