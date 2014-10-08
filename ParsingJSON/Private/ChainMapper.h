#import "Mapper.h"

@interface ChainMapper : NSObject <Mapper>

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE("Use initWithMappers: instead");
- (instancetype)initWithMappers:(NSArray *)mappers;

@end
