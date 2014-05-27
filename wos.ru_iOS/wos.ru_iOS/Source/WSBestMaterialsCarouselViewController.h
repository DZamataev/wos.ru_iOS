//
//  WSBestMaterialsCarouselViewController.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/23/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>
#import <UIImageView+WebCache.h>
#import "WSMaterialsModel.h"

@class WSBestMaterialView;

@interface WSBestMaterialsCarouselViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
{
}
@property IBOutlet iCarousel *carousel;
@property WSMaterialsModel *materialsModel;
@property CGSize itemSize;
@end
