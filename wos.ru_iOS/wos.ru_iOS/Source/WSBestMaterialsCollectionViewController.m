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

@implementation WSBestMaterialsCollectionViewController

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
//    view.title.text = material.title;
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
    [view.imageView setImageWithURL: [NSURL URLWithString:material.pictureStr]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSMaterial *material = self.materialsModel.materialsCollection.bestMaterials[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSOpenUrlNotification" object:Nil userInfo:@{@"url":[NSURL URLWithString:material.urlStr]}];
}

@end