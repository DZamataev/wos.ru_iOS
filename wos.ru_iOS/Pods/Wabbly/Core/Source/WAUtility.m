#import "WAUtility.h"
@implementation WAUtility

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass withNibOwner:(id)owner andNumber:(int)num
{
    if (nibName && objClass) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
        
        for (id currentObject in objects ){
            if ([currentObject isKindOfClass:objClass]) {
                num--;
                if (num <= 0) {
                    return currentObject;
                }
            }
        }
    }
    
    return nil;
}

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass withNibOwner:(id)owner
{
    return [WAUtility loadNibNamed:nibName ofClass:objClass withNibOwner:owner andNumber:0];
}

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass
{
    return [WAUtility loadNibNamed:nibName ofClass:objClass withNibOwner:nil andNumber:0];
}

+ (id)loadNibNamedAsClassWithUIIdiomSuffix:(Class)objClass
{
    if (objClass) {
        NSString *nibNameWithSuffix = [WAUtility nibNameForClassWithDeviceIdiomSpecificSuffix:objClass];
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibNameWithSuffix owner:nil options:nil];
        
        for (id currentObject in objects ){
            if ([currentObject isKindOfClass:objClass]) {
                return currentObject;
            }
        }
    }
    
    return nil;
}

+(void)displayConnectionError:(UIViewController*)delegateController;
{
    UIAlertView *connectionErrorAlertView = [[UIAlertView alloc]
                                             initWithTitle:NSLocalizedString(@"Connection error!", @"Alert view title on connection error.")
                                             message:NSLocalizedString(@"Can't connect. Please check your internet connection.", @"Alert view message on connection error.")
                                             delegate:delegateController
                                             cancelButtonTitle:NSLocalizedString(@"ConnectionErrorCancel", @"Alert view cancel button title on connection error.")
                                             otherButtonTitles: nil];
    [connectionErrorAlertView show];
}

+(NSString*)stringWithPrependingPlusSignIfNoMinusForString:(NSString*)s
{
    if (s != nil && ![s isEqualToString:@""] && ![[s substringToIndex:1] isEqualToString:@"-"])
    {
        return [NSString stringWithFormat:@"+%@", s];
    }
    return s;
}

+(NSString*)stringWithDateWordFormat:(NSDate *)date{
    
    NSString  *result;
    
    if (!date) {
        return nil;
    }
    
    NSDate *curDate = [NSDate date];
    
    if (([date  compare:curDate] == NSOrderedSame) || ([date   compare:curDate] == NSOrderedAscending)) {
        
        NSDateFormatter *dFormShort = [[NSDateFormatter alloc] init];
        [dFormShort setDateFormat:@"dd.MM.yyyy"];
        
        NSDateFormatter *dFormFull = [[NSDateFormatter alloc] init];
        [dFormFull setDateFormat:@"dd.MM.yyyy hh.mm.ss"];

        
        
        
        NSTimeInterval minute = -60;
        NSTimeInterval fiveMins = 5*minute;
        NSTimeInterval hour = 60 * minute;
        NSTimeInterval halfHour = hour/2;
        NSTimeInterval twoHours = 2*hour;

        
        
        
        NSDate *dateMinuteAhead = [curDate dateByAddingTimeInterval:minute];
        NSDate *dateFiveMinuteAhead = [curDate dateByAddingTimeInterval:fiveMins];
        NSDate *dateHalfHourAhead = [curDate dateByAddingTimeInterval:halfHour];
        NSDate *dateHourAhead = [curDate dateByAddingTimeInterval:hour];
        NSDate *dateTwoHoursAhead = [curDate dateByAddingTimeInterval:twoHours];
        
        
        if (([date  compare:dateMinuteAhead] == NSOrderedSame) || ([date   compare:dateMinuteAhead] == NSOrderedDescending)) {
            result = @"1 минуту назад";
        }
        else if (([date  compare:dateFiveMinuteAhead] == NSOrderedSame) || ([date   compare:dateFiveMinuteAhead] == NSOrderedDescending)){
            result = @"5 минут назад";
        }
        else if (([date  compare:dateHalfHourAhead] == NSOrderedSame) || ([date   compare:dateHalfHourAhead] == NSOrderedDescending)){
            result = @"пол часа назад";
        }
        else if (([date  compare:dateHourAhead] == NSOrderedSame) || ([date   compare:dateHourAhead] == NSOrderedDescending)){
            result = @"час назад";
        }
        else if (([date  compare:dateTwoHoursAhead] == NSOrderedSame) || ([date   compare:dateTwoHoursAhead] == NSOrderedDescending)){
            result = @"2 часа назад";
        }
        else{
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1;
            
            NSCalendar *theCalendar = [NSCalendar currentCalendar];
            
            NSDateFormatter *dFormShort = [[NSDateFormatter alloc] init];
            [dFormShort setDateFormat:@"dd.MM.yyyy"];
            
            NSDateFormatter *dFormFull = [[NSDateFormatter alloc] init];
            [dFormFull setDateFormat:@"dd.MM.yyyy HH.mm.ss"];
            
            NSDate  *curDayNight = [dFormFull dateFromString:[NSString stringWithFormat:@"%@ 00.00.00",[dFormShort stringFromDate:curDate]]];
            
            NSDate *yesterday = [theCalendar dateByAddingComponents:dayComponent toDate:curDayNight options:0];
            
            dayComponent = [[NSDateComponents alloc]    init];
            dayComponent.week = -1;
            
            NSDate *weekAgo = [theCalendar dateByAddingComponents:dayComponent toDate:curDayNight options:0];
            
            if (([date  compare:curDayNight] == NSOrderedSame) || ([date   compare:curDayNight] == NSOrderedDescending)) {
                result = @"сегодня";
            }
            else if (([date  compare:yesterday] == NSOrderedSame) || ([date   compare:yesterday] == NSOrderedDescending)){
                result = @"вчера";
            }
            else if (([date  compare:weekAgo] == NSOrderedSame) || ([date   compare:weekAgo] == NSOrderedDescending)){
                result = @"неделю назад";
            }


        }

    }
        else{
            result =  @"будущее";
        }
    
    return result;
}

+ (NSMutableArray*)getAllSubviewsForObject:(id)obj
{
    NSMutableArray *result = [NSMutableArray new];
    if (obj && [obj respondsToSelector:@selector(subviews)])
    {
        NSArray *subviews = ((UIView*)obj).subviews;
        for (int i = 0; i < subviews.count ; i++)
        {
            id subObj = [subviews objectAtIndex:i];
            [result addObject:subObj];
            NSArray *deeper = [WAUtility getAllSubviewsForObject:subObj];
            if (deeper && deeper.count > 0) {
                [result addObjectsFromArray:deeper];
            }
        }
    }
    return result;
}

+(void)showViewAnimated:(UIView*)view withSuccessCallback:(void (^)(UIView* view))block andDuration:(float)duration {
    if (!view)
        return;
    
    view.hidden = NO;
    view.alpha = 0.0f;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         view.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         if (block)
                         {
                             block(view);
                         }
                     }];
}

+(void)showViewAnimated:(UIView*)view withSuccessCallback:(void (^)(UIView* view))block {
    [self showViewAnimated:view withSuccessCallback:block andDuration:0.3f];
}

+(void)hideViewAnimated:(UIView*)view withSuccessCallback:(void (^)(UIView* view))block andDuration:(float)duration {
    view.alpha = 1.0f;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         view.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         view.hidden = YES;
                         if (block)
                         {
                             block(view);
                         }
                     }];
}

+(void)hideViewAnimated:(UIView*)view withSuccessCallback:(void (^)(UIView* view))block {
    [self hideViewAnimated:view withSuccessCallback:block andDuration:0.3f];
}

+(void)addUpperCornerRoundingMaskToView:(UIView*)view
{
    UIBezierPath    *path = [UIBezierPath   bezierPathWithRoundedRect:view.frame byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = view.bounds;
    maskLayer.path = path.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    view.layer.mask = maskLayer;
}


+(NSString*)nibNameForClassWithDeviceIdiomSpecificSuffix:(Class)cl
{
    NSString *suffix = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        suffix = @"_iPhone";
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        suffix = @"_iPad";
    }
    NSString *nibName = [NSString stringWithFormat:@"%@%@", NSStringFromClass(cl), suffix];
    return nibName;
}

+(void)setLabel:(UILabel*)label text:(NSString*)text andResizeItToFitLabelsWidthConstrainedToHeight:(float)maxHieght
{
    
    if (label && text) {
        CGSize constraint = CGSizeMake(label.frame.size.width , maxHieght);
        UIFont *font = [UIFont fontWithName:label.font.familyName size:label.font.pointSize];
        NSDictionary *attributes = @{NSFontAttributeName : font};
        CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                      options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                   attributes:attributes
                                                      context:nil].size;
        CGSize size = CGSizeMake(ceilf(boundingBox.width), ceilf(boundingBox.height));
        
        label.text = text;
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, size.height);
    }
}

+ (NSString *) dateToName:(NSDate*)dt withSec:(BOOL)sec {
    
    NSLocale *locale = [NSLocale currentLocale];
    NSTimeInterval tI = [[NSDate date] timeIntervalSinceDate:dt];
    if (tI < 60) {
        if (sec == NO) {
            return NSLocalizedString(@"Just Now", @"");
        }
        return [NSString stringWithFormat:
                NSLocalizedString(@"%d seconds ago", @""),(int)tI];
    }
    if (tI < 3600) {
        return [NSString stringWithFormat:
                NSLocalizedString(@"%d minutes ago", @""),(int)(tI/60)];
    }
    if (tI < 86400) {
        return [NSString stringWithFormat:
                NSLocalizedString(@"%d hours ago", @""),(int)tI/3600];
    }
    
    NSDateFormatter *relativeDateFormatter = [[NSDateFormatter alloc] init];
    [relativeDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [relativeDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [relativeDateFormatter setDoesRelativeDateFormatting:YES];
    [relativeDateFormatter setLocale:locale];
    
    NSString * relativeFormattedString =
    [relativeDateFormatter stringForObjectValue:dt];
    return relativeFormattedString;
}



@end
