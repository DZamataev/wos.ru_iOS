//
//  WSFeedTableViewController.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSFeedTableViewController.h"
#import "WSFeedItemView.h"
#import "WSFeedHeaderView.h"
#import "WSFeedLoader.h"
#import "WSFeedItem.h"
#import "WSFeedGroup.h"

@interface WSFeedTableViewController ()

@end

@implementation WSFeedTableViewController

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
    self.feedLoader = [[WSFeedLoader alloc] init];
    [self.feedLoader loadFeedWithCompletionBlock:^(NSMutableArray *groups, NSError *error, BOOL isOld) {
        _objects = groups;
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1f];
    }];
    
    for (id dummyView in _dummiesContainer.subviews) {
        if ([dummyView isKindOfClass:[WSFeedItemView class]]) {
            _dummyFeedItemView = dummyView;
        }
    }
    
    _placeholderImage = [WSFeedTableViewController imageWithColor:[UIColor darkGrayColor] andSize:_dummyFeedItemView.imageView.frame.size];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _objects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int retval = 0;
    WSFeedGroup *category = _objects[section];
    retval = category.items.count;
    return retval;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSFeedGroup *group = _objects[indexPath.section];
    WSFeedItem *item = group.items[indexPath.row];
    
    [self setValuesInItemView:_dummyFeedItemView fromItem:item];
    [_dummyFeedItemView setNeedsLayout];
    [_dummyFeedItemView layoutIfNeeded];
    
    return _dummyFeedItemView.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSFeedGroup *group = _objects[indexPath.section];
    WSFeedItem *item = group.items[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    WSFeedItemView *itemView = (WSFeedItemView*)[cell viewWithTag:1];
    
    [self setValuesInItemView:itemView fromItem:item];
    
    return cell;
}

- (void)setValuesInItemView:(WSFeedItemView*)view fromItem:(WSFeedItem*)item
{
    view.titleLabel.text = item.title;
    view.descriptionLabel.text = item.snippet;
    view.dateLabel.text = item.visibleDate;
    [view.imageView setImageWithURL:item.imageUrl placeholderImage:_placeholderImage];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WSFeedGroup *group = _objects[section];
    
    UITableViewCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"FeedHeaderCell"];
    WSFeedHeaderView *headerView = (WSFeedHeaderView*)[headerCell viewWithTag:1];
    headerView.titleLabel.text = group.userVisibleDate;
    
    return headerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSFeedGroup *group = _objects[indexPath.section];
    WSFeedItem *item = group.items[indexPath.row];
    
    if (item.linkUrl) {
        [CHWebBrowserViewController openWebBrowserControllerModallyWithHomeUrl:item.linkUrl animated:YES];
    }
}

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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
