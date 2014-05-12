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

@interface WSMaterialsTableViewController : UITableViewController
{
    UIRefreshControl *_refreshControl;
    WSMicroMaterialsCollectionViewController *_microMaterialsCollectionVC;
    WSBestMaterialsCollectionViewController *_bestMaterialsCollectionVC;
}
@property WSMaterialsModel *materialsModel;
@end
