#import "NSMutableArray+WAAdditions.h"

@implementation NSMutableArray (WAAdditions)

+ (instancetype)wa_loadFromDiskOrInstantiateNewWithFileName:(NSString*)fileName
{
    NSMutableArray *unarchivedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSMutableArray wa_filePathWithFileName:fileName]];
    if (!unarchivedArray)
    {
        unarchivedArray = [NSMutableArray new];
    }
    return unarchivedArray;
}

+ (NSString*)wa_filePathWithFileName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: fileName];
    return filePath;
}

- (void)wa_saveOnDiskWithFileName:(NSString*)fileName
{
    [NSKeyedArchiver archiveRootObject:self toFile:[NSMutableArray wa_filePathWithFileName:fileName]];
}

- (void)wa_insertObject:(id)objectToInsert removingMatchingWithComparisonBlock:(BOOL (^)(id objectToInsert, id anotherObject))matchBlock
    atIndexAfterRemoval:(NSUInteger (^)(NSMutableArray* array))indexCalculationBlock
{
    [self wa_removeObjectsMatchingObject:objectToInsert withComparisonBlock:matchBlock];
    [self insertObject:objectToInsert atIndex:indexCalculationBlock(self)];
}

- (void)wa_removeObjectsMatchingObject:(id)objectToRemove withComparisonBlock:(BOOL (^)(id , id ))matchBlock
{
    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet new];
    for (NSUInteger i = 0; i < self.count; i++) {
        id item = self[i];
        if (matchBlock(objectToRemove, item)) {
            [indexesToRemove addIndex:i];
        }
    }
    [self removeObjectsAtIndexes:indexesToRemove];
}

@end
