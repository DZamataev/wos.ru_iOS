//
//  WSSleepTimerSelectionCell.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/17/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSSleepTimerSelectionCell.h"

@implementation WSSleepTimerSelectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.contentView.backgroundColor = [UIColor colorWithWhite:60.0f/255.0f alpha:1.0f];
            self.textLabel.textColor = [[UIApplication sharedApplication] keyWindow].tintColor;
        } completion:nil];
    }
    else {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.contentView.backgroundColor = [UIColor clearColor];
            self.textLabel.textColor = [UIColor blackColor];
        } completion:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.contentView.backgroundColor = [UIColor colorWithWhite:60.0f/255.0f alpha:1.0f];
            self.textLabel.textColor = [[UIApplication sharedApplication] keyWindow].tintColor;
        } completion:nil];
    }
    else {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.contentView.backgroundColor = [UIColor clearColor];
            self.textLabel.textColor = [UIColor blackColor];
        } completion:nil];
    }
    // Configure the view for the selected state
}


@end
