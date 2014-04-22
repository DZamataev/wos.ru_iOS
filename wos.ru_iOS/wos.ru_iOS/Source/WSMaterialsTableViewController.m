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
    
    [_dummyViewsContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[WSFeedItemView class]]) {
            _dummyItemView = obj;
        }
    }];
    
    


    self.materialsModel = [WSMaterialsModel new];
    
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
    [self.materialsModel loadMaterialsWithCompletion:^(WSMaterialsCollection *materialsCollection, NSError *error) {
        NSLog(@"%@", materialsCollection.materials);
        NSLog(@"%i", materialsCollection.microMaterials.count);
        [self.tableView reloadData];
    }];
}

- (void)setValuesInItemView:(WSFeedItemView*)view fromMaterial:(WSMaterial*)item
{
    view.titleLabel.text = item.title;
    view.descriptionLabel.text = item.lead;
    view.dateLabel.text = item.dateStr;
    [view.imageView setImageWithURL:[NSURL URLWithString:item.pictureStr] placeholderImage:nil];
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
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MicroCell" forIndexPath:indexPath];
        UIView *containerView = [cell viewWithTag:112];
        if (containerView.subviews.count == 0) {
            _microMaterialsCollectionVC.view.frame = containerView.bounds;
            _microMaterialsCollectionVC.view.tag = 112;
            [containerView addSubview:_microMaterialsCollectionVC.view];
        }
        [_microMaterialsCollectionVC.collectionView reloadData];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
        int index = indexPath.row - 2;
        WSMaterial *item = self.materialsModel.materialsCollection.otherMaterials[index];
        WSFeedItemView *view = (WSFeedItemView*)[cell viewWithTag:1];
        [self setValuesInItemView:view fromMaterial:item];
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
        result = 240.0f +
        (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone);
    }
    else {
        int index = indexPath.row - 2;
        WSMaterial *item = self.materialsModel.materialsCollection.otherMaterials[index];
        [self setValuesInItemView:_dummyItemView fromMaterial:item];
        [_dummyItemView setNeedsLayout];
        [_dummyItemView layoutIfNeeded];
        result = _dummyItemView.bounds.size.height +
        (int)(tableView.separatorStyle != UITableViewCellSeparatorStyleNone); // height of the cell should obey selected separator style
    }
    return result;
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
