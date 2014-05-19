//
//  WSBestMaterialsCollectionViewController.h
//  wos.ru_iOS
//
//  Created by Denis on 4/22/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "WSMaterialsModel.h"

@interface WSBestMaterialsCollectionViewController : UICollectionViewController
@property WSMaterialsModel *materialsModel;
@property CGFloat pagingPageWidth;
-(void)scrollToNearestPageInScrollView:(UIScrollView*)scrollView;
@end
