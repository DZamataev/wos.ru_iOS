//
//  WSMaterialsTableViewController.m
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSMaterialsTableViewController.h"

@interface WSMaterialsTableViewController ()

@end

@implementation WSMaterialsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.isNeedToDisplayBestMaterialsAsCarouselInsteadOfCollection = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
//    self.isNeedToDisplayBestMaterialsAsCarouselInsteadOfCollection = YES;
    
    self.audioPlayer = [[FSAudioStream alloc] init];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(loadMaterials)
              forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:_refreshControl];

    self.materialsModel = [WSMaterialsModel new];
    
    if (self.isNeedToDisplayBestMaterialsAsCarouselInsteadOfCollection) {
        _bestMaterialsCarouselVC = [self.storyboard
                                    instantiateViewControllerWithIdentifier:@"WSBestMaterialsCarouselViewController"];
        _bestMaterialsCarouselVC.materialsModel = self.materialsModel;
    }
    else {
        _bestMaterialsCollectionVC = [self.storyboard
                                      instantiateViewControllerWithIdentifier:@"WSBestMaterialsCollectionViewController"];
        _bestMaterialsCollectionVC.materialsModel = self.materialsModel;
    }
    
    _microMaterialsCollectionVC = [self.storyboard
                                   instantiateViewControllerWithIdentifier:@"WSMicroMaterialsCollectionViewController"];
    _microMaterialsCollectionVC.materialsModel = self.materialsModel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWSSplitViewControllerManagerChangedMasterVisibilityNotification:)
                                                 name:WSSplitViewControllerManagerChangedMasterVisibilityNotification
                                               object:nil];
    _shouldReinitBestMaterials = _shouldReinitMicroMaterials = YES;
    
    [self loadMaterials];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleWSSplitViewControllerManagerChangedMasterVisibilityNotification:(NSNotification*)notification
{
    [self performSelector:@selector(delayedReload) withObject:nil afterDelay:0.1f];
}

- (void)delayedReload {
    _shouldReinitBestMaterials = _shouldReinitMicroMaterials = YES;
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:WSSplitViewControllerManagerChangedMasterVisibilityNotification
                                                  object:nil];
}

#pragma mark - actions
- (void)loadMaterials
{
    [_refreshControl beginRefreshing];
    [self.materialsModel loadMaterialsWithCompletion:^(WSMaterialsCollection *materialsCollection, NSError *error) {
//        NSLog(@"%@", materialsCollection.materials);
//        NSLog(@"%i", materialsCollection.microMaterials.count);
        _shouldReinitBestMaterials = _shouldReinitMicroMaterials = YES;
        [_refreshControl endRefreshing];
        NSMutableIndexSet *mSectionsIndexSet =
        [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,
                                                                  [self numberOfSectionsInTableView:self.tableView])];
        [self.tableView reloadSections:mSectionsIndexSet
                      withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)setValuesInItemView:(WSFeedItemView*)view fromMaterial:(WSMaterial*)item onCalculateHeightFlag:(BOOL)calculateHeightFlag
{
    if (calculateHeightFlag) {
        view.imageView.image = nil;
    }
    else {
        UIImageView __weak *imageViewToAnimate = view.imageView;
        [view.imageView setImageWithURL:[NSURL URLWithString:item.pictureStr]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  if (imageViewToAnimate && cacheType == SDImageCacheTypeNone) {
                                      imageViewToAnimate.alpha = 0.0f;
                                      [UIView animateWithDuration:0.3f delay:0.0f options:0 animations:^{
                                          imageViewToAnimate.alpha = 1.0f;
                                      } completion:nil];
                                  }
                              }];
        [view setLightGradientHidden:!item.isSeen animated:NO];
        
        if (view.audioView) {
            WSMaterialsTableViewController __weak *weakSelf = self;
            [view.audioView setPlayCallback:^{
                if (weakSelf) {
                    [weakSelf handlePlayAction:item];
                }
            }];
            [view.audioView setPauseCallback:^{
                if (weakSelf) {
                    [weakSelf.audioPlayer stop];
                }
            }];
        }
    }
    view.titleLabel.text = item.title;
    view.descriptionLabel.text = item.lead;
    view.dateLabel.text = item.dateStr;
    
    [view setNeedsLayout];
    [view layoutIfNeeded];
}

- (void)handlePlayAction:(id)sender
{
    if ([sender isKindOfClass:[WSMaterial class]]) {
        WSMaterial *item = sender;
        [self.audioPlayer playFromURL:[NSURL URLWithString:item.mp3UrlStr]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + self.materialsModel.materialsCollection.otherMaterials.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    /* Best materials controller is displayed in cell 0 */
    if (indexPath.row == 0) {
        /* Best materials can be displayed as carousel or as collection */
        cell = [tableView dequeueReusableCellWithIdentifier:@"BestCell" forIndexPath:indexPath];
        UIView *containerView = [cell viewWithTag:1];
        
        if (self.isNeedToDisplayBestMaterialsAsCarouselInsteadOfCollection) {
            if (_shouldReinitBestMaterials) {
                _shouldReinitBestMaterials = NO;
                [_bestMaterialsCarouselVC.view removeFromSuperview];
                _bestMaterialsCarouselVC.view.frame = containerView.bounds;
                _bestMaterialsCarouselVC.itemSize = containerView.bounds.size;
                [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [_bestMaterialsCarouselVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
                [containerView addSubview:_bestMaterialsCarouselVC.view];
                
                NSDictionary *viewsDictionary = @{@"view":_bestMaterialsCarouselVC.view};
                //Create the constraints using the visual language format
                NSMutableArray *constraintsArray = [NSMutableArray new];
                [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                                       constraintsWithVisualFormat:@"H:|-[view]-|"
                                                       options:0 metrics:nil
                                                       views:viewsDictionary]];
                [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                                       constraintsWithVisualFormat:@"V:|-[view]-|"
                                                       options:0 metrics:nil
                                                       views:viewsDictionary]];
                [containerView addConstraints:constraintsArray];
            }
            [_bestMaterialsCarouselVC.carousel reloadData];
        }
        else {
            if (_shouldReinitBestMaterials) {
                _shouldReinitBestMaterials = NO;
                [_bestMaterialsCollectionVC.view removeFromSuperview];
                _bestMaterialsCollectionVC.view.frame = containerView.bounds;
//                _bestMaterialsCollectionVC.pagingPageWidth = containerView.bounds.size.width;
                [containerView addSubview:_bestMaterialsCollectionVC.view];
                
                NSDictionary *viewsDictionary = @{@"view":_bestMaterialsCollectionVC.view};
                //Create the constraints using the visual language format
                NSMutableArray *constraintsArray = [NSMutableArray new];
                [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                                       constraintsWithVisualFormat:@"H:|-[view]-|"
                                                       options:0 metrics:nil
                                                       views:viewsDictionary]];
                [constraintsArray addObjectsFromArray:[NSLayoutConstraint
                                                       constraintsWithVisualFormat:@"V:|-[view]-|"
                                                       options:0 metrics:nil
                                                       views:viewsDictionary]];
                [containerView addConstraints:constraintsArray];
            }
            [_bestMaterialsCollectionVC.collectionView reloadData];
//            [_bestMaterialsCollectionVC scrollToNearestPageInScrollView:_bestMaterialsCollectionVC.collectionView];
        }
    }
    /* Micro materials controller is displayed in cell 1 */
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MicroCell" forIndexPath:indexPath];
        UIView *containerView = [cell viewWithTag:1];
        if (_shouldReinitMicroMaterials) {
            _shouldReinitMicroMaterials = NO;
            [_microMaterialsCollectionVC.view removeFromSuperview];
            _microMaterialsCollectionVC.view.frame = containerView.bounds;
            [containerView addSubview:_microMaterialsCollectionVC.view];
        }
        [_microMaterialsCollectionVC.collectionView reloadData];
    }
    /* Other materials are displayed in remaining cells starting from 2 */
    else {
        long index = indexPath.row - 2;
        WSMaterial *item = self.materialsModel.materialsCollection.otherMaterials[index];
        NSString *cellIdentifier = @"ItemCell";
        if (item.mp3UrlStr && item.mp3UrlStr.length > 0) {
            cellIdentifier = @"AudioItemCell";
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        WSFeedItemView *view = (WSFeedItemView*)[cell viewWithTag:1];
        [self setValuesInItemView:view fromMaterial:item onCalculateHeightFlag:NO];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 44.0f;
    if (indexPath.row == 0) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            result = 300.0f +
            (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone);
        }
        else
        {
            result = 110.0f +
            (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone);
        }
    
    }
    else if (indexPath.row == 1) {
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            result = 250.0f +
            (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone);
        }
        else {
            result = 230.0f +
            (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone);
        }
    }
    else {
        int index = indexPath.row - 2;
        WSMaterial *item = self.materialsModel.materialsCollection.otherMaterials[index];
        NSString *cellIdentifier = @"ItemCell";
        if (item.mp3UrlStr && item.mp3UrlStr.length > 0) {
            cellIdentifier = @"AudioItemCell";
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        WSFeedItemView *view = (WSFeedItemView*)[cell viewWithTag:1];
        
        [self setValuesInItemView:view fromMaterial:item onCalculateHeightFlag:YES];
        
        CGSize rect = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        result = rect.height +
        (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone); // height of the cell should obey selected separator style
//        NSLog(@"calculated rect: %@", NSStringFromCGSize(rect));
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 2) {
        int index = indexPath.row - 2;
        WSMaterial *material = self.materialsModel.materialsCollection.otherMaterials[index];
        [_materialsModel markMaterialAsSeenWithIdentifier:material.identifier];
        material.isSeen = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WSOpenUrlNotification" object:Nil userInfo:@{@"url":[NSURL URLWithString:material.urlStr]}];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
     CGRect rect = CGRectMake(0, 0, size.width, size.height);
     UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
     [color setFill];
     UIRectFill(rect);
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     return image;
 }


@end
