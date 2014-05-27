//
//  WSBestMaterialView.h
//  wos.ru_iOS
//
//  Created by Denis on 4/22/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSBestMaterialView : UIView
@property IBOutlet UIImageView *imageView;
@property IBOutlet UILabel *title;
@property IBOutlet UILabel *subtitle;
@property IBOutlet UILabel *viewsCount;
@property IBOutlet UILabel *commentsCount;
@property IBOutlet NSLayoutConstraint *heightConstraint;
@end
