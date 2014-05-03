//
//  WSMaterialsTableViewController.h
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSMaterialsModel.h"
#import "WSFeedItemView.h"
#import "WSMicroMaterialsCollectionViewController.h"
#import "WSBestMaterialsCollectionViewController.h"

@interface WSMaterialsTableViewController : UITableViewController
{
    IBOutlet UIView * _dummyViewsContainer;
    UIRefreshControl *_refreshControl;
    WSFeedItemView *_dummyItemView;
    WSMicroMaterialsCollectionViewController *_microMaterialsCollectionVC;
    WSBestMaterialsCollectionViewController *_bestMaterialsCollectionVC;
}
@property WSMaterialsModel *materialsModel;
@end
