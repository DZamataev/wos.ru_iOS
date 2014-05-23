//
//  WSFeedCell.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 2/20/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WSFeedItemView : UIView {
    CALayer *_gradientBgViewLayer;
    IBOutlet UIView *_gradientBgView;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
- (void)setLightGradientHidden:(BOOL)hidden animated:(BOOL)animated;
+ (UIColor *)wosGrayColor;
@end
