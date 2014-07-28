//
//  WSSleepTimerPickerViewController.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/17/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSSleepTimerPickerViewController.h"
#import "WSRadioViewController.h"

#define WSSleepTimerPickerData ( @[ @(-1), @(5), @(10), @(15), @(30), @(45), @(60) ] )

@interface WSSleepTimerPickerViewController ()

@end

@implementation WSSleepTimerPickerViewController

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
}

- (IBAction)selectActualItem:(id)sender
{
    NSNumber *pickedInterval = [[NSUserDefaults standardUserDefaults] objectForKey:WSSleepTimerPickedInterval_UserDefaultsKey];
    if (pickedInterval) {
        NSArray *pseudoData = WSSleepTimerPickerData;
        for (NSNumber *dataNumber in pseudoData) {
            if (pickedInterval.intValue == dataNumber.intValue) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[pseudoData indexOfObject:dataNumber] inSection:0]
                                            animated:NO
                                      scrollPosition:UITableViewScrollPositionNone];
                break;
            }
        }
    }
    else {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *pseudoData = WSSleepTimerPickerData;
    if (pseudoData.count > indexPath.row) {
        NSNumber *selectedNumber = pseudoData[indexPath.row];
        NSLog(@"Selected sleep timer interval %i minutes", selectedNumber.intValue);
        // Analytics
        [PFAnalytics trackEvent:@"sleep timer set up"
                     dimensions:@{@"interval":@(selectedNumber.intValue).stringValue}];
        //
        if (self.delegate) [self.delegate sleepTimerPickerViewController:self pickedTimeInterval:selectedNumber];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/* we use static cells from storyboard */
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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
