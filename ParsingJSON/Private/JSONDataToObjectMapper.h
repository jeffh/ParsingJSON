#import "Mapper.h"

@interface JSONDataToObjectMapper : NSObject <Mapper>

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE("Use initWithErrorDomain:errorCode: instead");
- (instancetype)initWithErrorDomain:(NSString *)errorDomain
                          errorCode:(NSInteger)errorCode;

@end
