//
//  WSRadiostationButton.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSRadiostationButton : UIControl
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) void (^touchUpInsideCallback)(WSRadiostationButton *sender);
@end
