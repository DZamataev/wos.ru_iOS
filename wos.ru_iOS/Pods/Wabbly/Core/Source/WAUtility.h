#import <Foundation/Foundation.h>

#define float_epsilon 0.00001f

#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

@interface WAUtility : NSObject

+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass withNibOwner:(id)owner andNumber:(int)num;
+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass withNibOwner:(id)owner;
+ (id)loadNibNamed:(NSString *)nibName ofClass:(Class)objClass;
+ (id)loadNibNamedAsClassWithUIIdiomSuffix:(Class)objClass;

+(void)displayConnectionError:(UIViewController*)delegateController;


+(NSString*)stringWithPrependingPlusSignIfNoMinusForString:(NSString*)s;

+(NSString*)stringWithDateWordFormat:(NSDate*)date;

+ (NSMutableArray*)getAllSubviewsForObject:(id)obj;

+(void)showViewAnimated:(UIView*)view withSuccessCallback:(void (^)(UIView* view))block andDuration:(float)duration;
+(void)hideViewAnimated:(UIView*)view withSuccessCallback:(void (^)(UIView* view))block andDuration:(float)duration;
+(void)showViewAnimated:(UIView*)view withSuccessCallback:(void (^)(UIView* view))block;
+(void)hideViewAnimated:(UIView*)view withSuccessCallback:(void (^)(UIView* view))block;

+(void)addUpperCornerRoundingMaskToView:(UIView*)view;

+(void)setLabel:(UILabel*)label text:(NSString*)text andResizeItToFitLabelsWidthConstrainedToHeight:(float)maxHieght;

+(NSString*)nibNameForClassWithDeviceIdiomSpecificSuffix:(Class)cl;

+ (NSString *) dateToName:(NSDate*)dt withSec:(BOOL)sec;
@end
