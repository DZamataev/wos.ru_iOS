//
//  WSRadiostationSelectorScrollView.h
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 1/14/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSRadiostationButton;

@interface WSRadiostationSelectorScrollView : UIScrollView
{
    UIView *_backgroundPatternView;
    NSMutableArray *_buttons;
}

- (void)addButtonsWithTitles:(NSArray*)titles andColors:(NSArray*)colors andSelectionCallback:(void (^)(WSRadiostationButton *button, NSInteger index))selectionCallback;

@end
