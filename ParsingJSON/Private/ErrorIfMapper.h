#import "Mapper.h"

@interface ErrorIfMapper : NSObject <Mapper>

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE("Use initWithErrorDomain:errorCode:ifJSONKeyExists:");
- (instancetype)initWithErrorDomain:(NSString *)errorDomain
                          errorCode:(NSInteger)errorCode
                           userInfo:(NSDictionary *)userInfo
               errorIfJSONKeyExists:(NSString *)jsonKey;

@end
