#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (WAAdditions)

@property (nonatomic, assign) UIColor* borderUIColor;
@property (nonatomic, assign) UIColor* shadowUIColor;
@property (nonatomic, assign) BOOL rasterizationScaleWithMainScreenScale;
@end
