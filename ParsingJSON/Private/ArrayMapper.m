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

- (id)objectFromSourceObject:(id)jsonObject error:(__autoreleasing NSError **)error {
    NSMutableArray *transformedItems = [NSMutableArray array];
    for (id item in jsonObject) {
        NSError *itemError = nil;
        id transformedItem = [self.itemMapper objectFromSourceObject:item error:&itemError];
        if (itemError && ![itemError.userInfo[kIsNonFatalKey] boolValue]) {
            *error = itemError;
            return nil;
        } else if (!itemError) {
            [transformedItems addObject:transformedItem];
        }
    }
    return transformedItems;
}

@end
