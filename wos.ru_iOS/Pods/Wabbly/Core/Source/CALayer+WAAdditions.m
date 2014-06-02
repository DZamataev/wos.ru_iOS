#import "CALayer+WAAdditions.h"

@implementation CALayer (WAAdditions)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}


-(void)setShadowUIColor:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

-(UIColor*)shadowUIColor
{
    return [UIColor colorWithCGColor:self.shadowColor];
}

-(void)setRasterizationScaleWithMainScreenScale:(BOOL)rasterizationScaleWithMainScreenScale
{
    if (rasterizationScaleWithMainScreenScale) {
        self.rasterizationScale = [UIScreen mainScreen].scale;
    }
}

-(BOOL)rasterizationScaleWithMainScreenScale
{
    return self.rasterizationScale == [UIScreen mainScreen].scale;
}

@end
