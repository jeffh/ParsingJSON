#import "Mapper.h"

@interface OptionalMapper : NSObject <Mapper>

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE("Use initWithMapper: instead");
- (instancetype)initWithMapper:(id<Mapper>)mapper;

@end
