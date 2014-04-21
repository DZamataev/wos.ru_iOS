//
//  WSMaterialsViewController.m
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSMaterialsViewController.h"

@interface WSMaterialsViewController ()

@end

@implementation WSMaterialsViewController

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
    self.materialsModel = [WSMaterialsModel new];
    [self loadMaterials];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMaterials
{
    [self.materialsModel loadMaterialsWithCompletion:^(WSMaterialsCollection *materialsCollection, NSError *error) {
        NSLog(@"%@", materialsCollection.materials);
    }];
}

@end
