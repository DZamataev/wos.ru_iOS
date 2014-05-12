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
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                        action:@selector(loadMaterials)
              forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:_refreshControl];

    self.materialsModel = [WSMaterialsModel new];
    
    _bestMaterialsCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WSBestMaterialsCollectionViewController"];
    _bestMaterialsCollectionVC.materialsModel = self.materialsModel;
    
    _microMaterialsCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WSMicroMaterialsCollectionViewController"];
    _microMaterialsCollectionVC.materialsModel = self.materialsModel;
    
    [self loadMaterials];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)loadMaterials
{
    [_refreshControl beginRefreshing];
    [self.materialsModel loadMaterialsWithCompletion:^(WSMaterialsCollection *materialsCollection, NSError *error) {
//        NSLog(@"%@", materialsCollection.materials);
//        NSLog(@"%i", materialsCollection.microMaterials.count);
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
        
    }
    view.titleLabel.text = item.title;
    view.descriptionLabel.text = item.lead;
    view.dateLabel.text = item.dateStr;
    [view setNeedsLayout];
    [view layoutIfNeeded];
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
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BestCell" forIndexPath:indexPath];
        NSInteger tag = 111;
        UIView *containerView = [cell viewWithTag:tag];
        if (containerView.subviews.count == 0) {
            [_bestMaterialsCollectionVC.view removeFromSuperview];
            _bestMaterialsCollectionVC.view.frame = containerView.bounds;
            _bestMaterialsCollectionVC.view.tag = tag;
            [containerView addSubview:_bestMaterialsCollectionVC.view];
        }
        [_bestMaterialsCollectionVC.collectionView reloadData];
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MicroCell" forIndexPath:indexPath];
        NSInteger tag = 112;
        UIView *containerView = [cell viewWithTag:tag];
        if (containerView.subviews.count == 0) {
            [_microMaterialsCollectionVC.view removeFromSuperview];
            _microMaterialsCollectionVC.view.frame = containerView.bounds;
            _microMaterialsCollectionVC.view.tag = tag;
            [containerView addSubview:_microMaterialsCollectionVC.view];
        }
        [_microMaterialsCollectionVC.collectionView reloadData];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
        int index = indexPath.row - 2;
        WSMaterial *item = self.materialsModel.materialsCollection.otherMaterials[index];
        WSFeedItemView *view = (WSFeedItemView*)[cell viewWithTag:1];
        [self setValuesInItemView:view fromMaterial:item onCalculateHeightFlag:NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 44.0f;
    if (indexPath.row == 0) {
        result = 110.0f +
        (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone);
    
    }
    else if (indexPath.row == 1) {
        result = 230.0f +
        (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone);
    }
    else {
        int index = indexPath.row - 2;
        WSMaterial *item = self.materialsModel.materialsCollection.otherMaterials[index];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        WSFeedItemView *view = (WSFeedItemView*)[cell viewWithTag:1];
        
        [self setValuesInItemView:view fromMaterial:item onCalculateHeightFlag:YES];
        
        CGSize rect = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        result = rect.height +
        (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone); // height of the cell should obey selected separator style
//        NSLog(@"calculated height: %f", result);
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 2) {
        int index = indexPath.row - 2;
        WSMaterial *material = self.materialsModel.materialsCollection.otherMaterials[index];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WSOpenUrlNotification" object:Nil userInfo:@{@"url":[NSURL URLWithString:material.urlStr]}];
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

@end
