#import "Mapper.h"

@interface NonNilMapper : NSObject <Mapper>

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE("Use initWithErrorDomain:errorCode:ifJSONKeyExists:");
- (instancetype)initWithErrorDomain:(NSString *)errorDomain
                          errorCode:(NSInteger)errorCode
                           userInfo:(NSDictionary *)userInfo;

@end
