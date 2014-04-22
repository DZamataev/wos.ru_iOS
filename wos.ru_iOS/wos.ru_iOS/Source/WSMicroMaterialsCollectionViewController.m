//
//  WSMicroMaterialsCollectionViewController.m
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSMicroMaterialsCollectionViewController.h"
#import "WSMicroMaterialView.h"

@interface WSMicroMaterialsCollectionViewController ()

@end

@implementation WSMicroMaterialsCollectionViewController {
    NSInteger _currentPage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%i", self.materialsModel.materialsCollection.microMaterials.count);
    return self.materialsModel.materialsCollection.microMaterials.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultCell" forIndexPath:indexPath];
    WSMaterial *material = self.materialsModel.materialsCollection.microMaterials[indexPath.row];
    WSMicroMaterialView *view = (WSMicroMaterialView*)[cell viewWithTag:1];
    view.title.text = material.title;
    view.subtitle.text = material.lead;
    [view.imageView setImageWithURL: [NSURL URLWithString:material.pictureStr]];
    return cell;
}

#pragma mark - UIScrollView delegate
// here is our custom paging

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.pagingPageWidth;
    
    _currentPage = floor((self.collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
//    NSLog(@"Dragging - You are now on page %i", _currentPage);
}

-(void) scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset {
    
    CGFloat pageWidth = self.pagingPageWidth;
    NSLog(@"dragging velocity %f", velocity.x);
    int newPage = _currentPage;
    
    if (velocity.x == 0) // slow dragging not lifting finger
    {
        newPage = floor((targetContentOffset->x - pageWidth / 2) / pageWidth) + 1;
        
        //    NSLog(@"Dragging - You will be on %i page (from page %i)", newPage, _currentPage);
        
        *targetContentOffset = CGPointMake(newPage * pageWidth, targetContentOffset->y);
    }
    else if (fabsf(velocity.x) < 1.0f)
    {
        newPage = velocity.x > 0 ? _currentPage + 1 : _currentPage - 1;
        
        if (newPage < 0)
            newPage = 0;
        if (newPage > self.collectionView.contentSize.width / pageWidth)
            newPage = ceil(self.collectionView.contentSize.width / pageWidth) - 1.0;
        
        
        //    NSLog(@"Dragging - You will be on %i page (from page %i)", newPage, _currentPage);
        
        *targetContentOffset = CGPointMake(newPage * pageWidth, targetContentOffset->y);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.pagingPageWidth;
    NSLog(@"end decelerating");
    int newPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    CGFloat targetX = newPage * pageWidth;
    [scrollView scrollRectToVisible:CGRectMake(targetX, 0, scrollView.bounds.size.width, scrollView.bounds.size.height) animated:YES];
}
@end
