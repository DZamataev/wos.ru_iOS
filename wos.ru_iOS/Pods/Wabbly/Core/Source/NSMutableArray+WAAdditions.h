#import <Foundation/Foundation.h>

@interface NSMutableArray (WAAdditions)
+ (instancetype)wa_loadFromDiskOrInstantiateNewWithFileName:(NSString*)fileName;
+ (NSString*)wa_filePathWithFileName:(NSString*)fileName;
- (void)wa_insertObject:(id)objectToInsert
removingMatchingWithComparisonBlock:(BOOL (^)(id objectToInsert, id anotherObject))matchBlock
    atIndexAfterRemoval:(NSUInteger (^)(NSMutableArray* array))indexCalculationBlock;
- (void)wa_removeObjectsMatchingObject:(id)objectToRemove withComparisonBlock:(BOOL (^)(id objectToRemove, id anotherObject))matchBlock;
- (void)wa_saveOnDiskWithFileName:(NSString*)fileName;

@end
