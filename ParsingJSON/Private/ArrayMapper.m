#import "ArrayMapper.h"

@interface ArrayMapper ()
@property (nonatomic) id<Mapper> itemMapper;
@end

@implementation ArrayMapper

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithItemMapper:(id<Mapper>)itemMapper {
    if (self = [super init]) {
        self.itemMapper = itemMapper;
    }
    return self;
}

- (id)objectFromJSONObject:(id)jsonObject error:(__autoreleasing NSError **)error {
    NSMutableArray *transformedItems = [NSMutableArray array];
    for (id item in jsonObject) {
        NSError *itemError = nil;
        id transformedItem = [self.itemMapper objectFromJSONObject:item error:&itemError];
        if (itemError) {
            *error = itemError;
            return nil;
        } else {
            [transformedItems addObject:transformedItem];
        }
    }
    return transformedItems;
}

@end
