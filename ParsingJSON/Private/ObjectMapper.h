#import "Mapper.h"

@interface ObjectMapper : NSObject <Mapper>

- (instancetype)initWithGeneratorOfClass:(Class)classOfObjectToCreate
                        jsonKeysToFields:(NSDictionary *)jsonKeysToFields
                         fieldsToMappers:(NSDictionary *)fieldsToMappers;

@end
