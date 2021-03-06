//
//  WSMicroMaterialsCollectionViewController.h
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "WSMaterialsModel.h"

@interface WSMicroMaterialsCollectionViewController : UICollectionViewController
@property WSMaterialsModel *materialsModel;
@property CGFloat pagingPageWidth;
@end
