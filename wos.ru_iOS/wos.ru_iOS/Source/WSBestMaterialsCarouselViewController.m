//
//  WSBestMaterialsCarouselViewController.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 5/23/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSBestMaterialsCarouselViewController.h"
#import "WSBestMaterialView.h"

@interface WSBestMaterialsCarouselViewController ()

@end

@implementation WSBestMaterialsCarouselViewController

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
    self.carousel.type = iCarouselTypeCoverFlow;
    self.itemSize = CGSizeZero;
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

#pragma mark - iCarouselDataSource protocol implementation
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.materialsModel.materialsCollection.bestMaterials.count;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    WSMaterial *material = self.materialsModel.materialsCollection.bestMaterials[index];
    [_materialsModel markMaterialAsSeenWithIdentifier:material.identifier];
    material.isSeen = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSOpenUrlNotification" object:Nil userInfo:@{@"url":[NSURL URLWithString:material.urlStr]}];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)containerView
{
    
//    UILabel *label = nil;
//    
//    //create new view if no view is available for recycling
//    if (containerView == nil)
//    {
//        containerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
//        ((UIImageView *)containerView).image = [UIImage imageNamed:@"ws_sleeping_timer_icon_white"];
//        containerView.contentMode = UIViewContentModeCenter;
//        label = [[UILabel alloc] initWithFrame:containerView.bounds];
//        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [label.font fontWithSize:50];
//        label.tag = 1;
//        [containerView addSubview:label];
//    }
//    else
//    {
//        //get a reference to the label in the recycled view
//        label = (UILabel *)[containerView viewWithTag:1];
//    }
//    
//    //set item label
//    //remember to always set any properties of your carousel item
//    //views outside of the `if (view == nil) {...}` check otherwise
//    //you'll get weird issues with carousel item content appearing
//    //in the wrong place in the carousel
//    label.text = [NSString stringWithFormat:@"%2.2i", rand()];
//    
//    return containerView;
    
    CGRect sizeRect = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
    
    if (containerView == nil) {
        UIViewController *bestMaterialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BestMaterialViewController"];
        containerView = bestMaterialVC.view;
        bestMaterialVC.view.bounds = sizeRect;
    }
    
    WSBestMaterialView *view = (WSBestMaterialView*)[containerView viewWithTag:1];
    view.heightConstraint.constant = sizeRect.size.height;
    
    WSMaterial *material = self.materialsModel.materialsCollection.bestMaterials[index];
    
    NSMutableAttributedString *titleMAS = [[NSMutableAttributedString alloc] initWithString:material.title];
    NSRange wholeStringRange = NSMakeRange(0, titleMAS.length);
    [titleMAS addAttribute:NSFontAttributeName
                value:[UIFont systemFontOfSize:view.title.font.pointSize]
                range:wholeStringRange];
    [titleMAS addAttribute:NSForegroundColorAttributeName
                value:[UIColor whiteColor]
                range:wholeStringRange];
    [titleMAS addAttribute:NSBackgroundColorAttributeName
                value:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:0.4f]
                range:wholeStringRange];
    view.title.attributedText = titleMAS;
    view.subtitle.text = material.lead;
    view.viewsCount.text = [NSString stringWithFormat:@"- %@", material.showCountNum.stringValue];
    view.commentsCount.text = [NSString stringWithFormat:@"%@ -", material.commentsCountNum.stringValue];
    
    UIImageView __weak *imageViewToAnimate = view.imageView;
    [view.imageView setImageWithURL:[NSURL URLWithString:material.pictureStr]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              if (imageViewToAnimate && cacheType == SDImageCacheTypeNone) {
                                  imageViewToAnimate.alpha = 0.0f;
                                  [UIView animateWithDuration:0.3f delay:0.0f options:0 animations:^{
                                      imageViewToAnimate.alpha = 1.0f;
                                  } completion:nil];
                              }
                          }];
    
    [containerView setNeedsLayout];
    [containerView layoutIfNeeded];
    
    return containerView;
}

@end
