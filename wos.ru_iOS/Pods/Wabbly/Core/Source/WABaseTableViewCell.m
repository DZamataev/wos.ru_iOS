#import "WABaseTableViewCell.h"
#import "WAUtility.h"

@implementation WABaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSArray*)allSubviews
{
    return [WAUtility getAllSubviewsForObject:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    NSArray *allSubviews = [self allSubviews];
    for (id view in allSubviews) {
        if ([view respondsToSelector:@selector(setSelected:animated:)]) {
            [view setSelected:selected animated:animated];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    NSArray *allSubviews = [self allSubviews];
    for (id view in allSubviews) {
        if ([view respondsToSelector:@selector(setHighlighted:animated:)]) {
            [view setHighlighted:highlighted animated:animated];
        }
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    NSArray *allSubviews = [self allSubviews];
    for (id view in allSubviews) {
        if ([view respondsToSelector:@selector(prepareForReuse)]) {
            [view prepareForReuse];
        }
    }
}

@end
