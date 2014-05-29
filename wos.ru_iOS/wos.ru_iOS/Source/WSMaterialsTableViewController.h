//
//  WSMaterialsTableViewController.h
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "WSMaterialsModel.h"
#import "WSFeedItemView.h"
#import "WSMicroMaterialsCollectionViewController.h"
#import "WSBestMaterialsCollectionViewController.h"
#import "WSBestMaterialsCarouselViewController.h"
#import "WSAudioFeedItemViewController.h"
#import "WSSplitViewControllerManager.h"

@interface WSMaterialsTableViewController : UITableViewController
{
    UIRefreshControl *_refreshControl;
    WSBestMaterialsCollectionViewController *_bestMaterialsCollectionVC;
    WSBestMaterialsCarouselViewController *_bestMaterialsCarouselVC;
    WSMicroMaterialsCollectionViewController *_microMaterialsCollectionVC;
    
    WSAudioFeedItemViewController *_audioController;
    
    BOOL _shouldReinitBestMaterials;
    BOOL _shouldReinitMicroMaterials;
    
    UIImage *_placeholderImage;
    
}
@property WSMaterialsModel *materialsModel;
@property BOOL isNeedToDisplayBestMaterialsAsCarouselInsteadOfCollection;
@end
