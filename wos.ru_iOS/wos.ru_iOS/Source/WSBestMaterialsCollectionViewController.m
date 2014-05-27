//
//  WSBestMaterialsCollectionViewController.m
//  wos.ru_iOS
//
//  Created by Denis on 4/22/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSBestMaterialsCollectionViewController.h"
#import "WSBestMaterialView.h"

@interface WSBestMaterialsCollectionViewController ()

@end

@implementation WSBestMaterialsCollectionViewController {
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
    return self.materialsModel.materialsCollection.bestMaterials.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultCell" forIndexPath:indexPath];
    WSMaterial *material = self.materialsModel.materialsCollection.bestMaterials[indexPath.row];
    WSBestMaterialView *view = (WSBestMaterialView*)[cell viewWithTag:1];
    
    CGRect cellRect = cell.frame;
    cell.frame = CGRectMake(cellRect.origin.x, cellRect.origin.y, _pagingPageWidth, cellRect.size.height);
    
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:material.title];
    NSRange wholeStringRange = NSMakeRange(0, mas.length);
    [mas addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:view.title.font.pointSize]
                range:wholeStringRange];
    [mas addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:wholeStringRange];
    [mas addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:0.4f] range:wholeStringRange];
    view.title.attributedText = mas;
    view.subtitle.text = material.lead;
    view.viewsCount.text = [NSString stringWithFormat:@"- %@", material.showCountNum.stringValue];
    view.commentsCount.text = [NSString stringWithFormat:@"%@ -", material.commentsCountNum.stringValue];
    
    UIImageView __weak *imageViewToAnimate = view.imageView;
    [view.imageView setImageWithURL:[NSURL URLWithString:material.pictureStr]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              if (imageViewToAnimate) {
                                  imageViewToAnimate.alpha = 0.0f;
                                  [UIView animateWithDuration:0.3f delay:0.0f options:0 animations:^{
                                      imageViewToAnimate.alpha = 1.0f;
                                  } completion:nil];
                              }
                          }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSMaterial *material = self.materialsModel.materialsCollection.bestMaterials[indexPath.row];
    [_materialsModel markMaterialAsSeenWithIdentifier:material.identifier];
    material.isSeen = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSOpenUrlNotification" object:Nil userInfo:@{@"url":[NSURL URLWithString:material.urlStr]}];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.pagingPageWidth, self.view.bounds.size.height);
}


#pragma mark - UIScrollView delegate
// here is our custom paging

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.pagingPageWidth;
    
    _currentPage = floor((self.collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

-(void) scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset {
    
    CGFloat pageWidth = self.pagingPageWidth;
    int newPage = _currentPage;
    
    if (velocity.x == 0) // slow dragging not lifting finger
    {
        newPage = floor((targetContentOffset->x - pageWidth / 2) / pageWidth) + 1;
        
        *targetContentOffset = CGPointMake(newPage * pageWidth, targetContentOffset->y);
    }
    else if (fabsf(velocity.x) < 1.0f)
    {
        newPage = velocity.x > 0 ? _currentPage + 1 : _currentPage - 1;
        
        if (newPage < 0)
            newPage = 0;
        if (newPage > self.collectionView.contentSize.width / pageWidth)
            newPage = ceil(self.collectionView.contentSize.width / pageWidth) - 1.0;
        
        *targetContentOffset = CGPointMake(newPage * pageWidth, targetContentOffset->y);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollToNearestPageInScrollView:scrollView];
}

-(void)scrollToNearestPageInScrollView:(UIScrollView*)scrollView
{
    CGFloat pageWidth = self.pagingPageWidth;
    int newPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    CGFloat targetX = newPage * pageWidth;
    
    [scrollView scrollRectToVisible:CGRectMake(targetX, 0, scrollView.bounds.size.width, scrollView.bounds.size.height) animated:YES];
}

@end
