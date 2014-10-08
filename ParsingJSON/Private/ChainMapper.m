#import "ChainMapper.h"

@interface ChainMapper ()
@property (nonatomic, copy) NSArray *mappers;
@end

@implementation ChainMapper

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return self;
}

- (instancetype)initWithMappers:(NSArray *)mappers {
    if (self = [super init]) {
        self.mappers = mappers;
    }
    return self;
}

- (id)objectFromSourceObject:(id)jsonObject error:(__autoreleasing NSError **)error {
    *error = nil;
    id result = jsonObject;
    for (id<Mapper> mapper in self.mappers) {
        result = [mapper objectFromSourceObject:result error:error];
        if (*error) {
            return nil;
        }
    }
    return result;
}

@end
