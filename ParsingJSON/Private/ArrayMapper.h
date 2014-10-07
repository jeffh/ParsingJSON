#import "Mapper.h"

@interface ArrayMapper : NSObject <Mapper>

- (instancetype)initWithItemMapper:(id<Mapper>)itemMapper;
- (instancetype)init DEPRECATED_MSG_ATTRIBUTE("use initWithItemMapper: instead");

@end
