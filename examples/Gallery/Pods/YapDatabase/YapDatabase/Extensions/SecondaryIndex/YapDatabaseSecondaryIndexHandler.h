#import <Foundation/Foundation.h>
#import "YapDatabaseExtensionTypes.h"


/**
 * The handler block handles extracting the column values for the secondary indexes.
 *
 * When you add or update rows in the databse the block is invoked.
 * Your block can inspect the row and determine if it contains any values that should be added to the secondary indexes.
 * If not, the  block can simply return.
 * Otherwise the block should extract any values and add them to the given dictionary.
 *
 * After the block returns, the dictionary parameter will be inspected,
 * and any set values will be automatically inserted/updated within the sqlite indexes.
 *
 * You should choose a block type that takes the minimum number of required parameters.
 * The extension can make various optimizations based on required parameters of the block.
 * For example, if metadata isn't required, then the extension can ignore metadata-only updates.
**/
@interface YapDatabaseSecondaryIndexHandler : NSObject

typedef id YapDatabaseSecondaryIndexBlock; // One of the YapDatabaseSecondaryIndexWith_X_Block types below.

typedef void (^YapDatabaseSecondaryIndexWithKeyBlock)
                            (NSMutableDictionary *dict, NSString *collection, NSString *key);
typedef void (^YapDatabaseSecondaryIndexWithObjectBlock)
                            (NSMutableDictionary *dict, NSString *collection, NSString *key, id object);
typedef void (^YapDatabaseSecondaryIndexWithMetadataBlock)
                            (NSMutableDictionary *dict, NSString *collection, NSString *key, id metadata);
typedef void (^YapDatabaseSecondaryIndexWithRowBlock)
                            (NSMutableDictionary *dict, NSString *collection, NSString *key, id object, id metadata);

+ (instancetype)withKeyBlock:(YapDatabaseSecondaryIndexWithKeyBlock)block;
+ (instancetype)withObjectBlock:(YapDatabaseSecondaryIndexWithObjectBlock)block;
+ (instancetype)withMetadataBlock:(YapDatabaseSecondaryIndexWithMetadataBlock)block;
+ (instancetype)withRowBlock:(YapDatabaseSecondaryIndexWithRowBlock)block;

+ (instancetype)withOptions:(YapDatabaseBlockInvoke)ops keyBlock:(YapDatabaseSecondaryIndexWithKeyBlock)block;
+ (instancetype)withOptions:(YapDatabaseBlockInvoke)ops objectBlock:(YapDatabaseSecondaryIndexWithObjectBlock)block;
+ (instancetype)withOptions:(YapDatabaseBlockInvoke)ops metadataBlock:(YapDatabaseSecondaryIndexWithMetadataBlock)block;
+ (instancetype)withOptions:(YapDatabaseBlockInvoke)ops rowBlock:(YapDatabaseSecondaryIndexWithRowBlock)block;

@property (nonatomic, strong, readonly) YapDatabaseSecondaryIndexBlock block;
@property (nonatomic, assign, readonly) YapDatabaseBlockType           blockType;
@property (nonatomic, assign, readonly) YapDatabaseBlockInvoke         blockInvokeOptions;

@end
