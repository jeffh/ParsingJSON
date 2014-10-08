#import "ObjectMapper.h"

@interface ObjectMapper ()
@property (nonatomic) Class classOfObjectToCreate;
@property (nonatomic, copy) NSDictionary *jsonKeysToFields;
@property (nonatomic, copy) NSDictionary *fieldsToMappers;
@end


@implementation ObjectMapper

- (instancetype)initWithGeneratorOfClass:(Class)classOfObjectToCreate
                        jsonKeysToFields:(NSDictionary *)jsonKeysToFields
                         fieldsToMappers:(NSDictionary *)fieldsToMappers {
    if (self = [super init]) {
        self.classOfObjectToCreate = classOfObjectToCreate;
        self.jsonKeysToFields = jsonKeysToFields;
        self.fieldsToMappers = fieldsToMappers;
    }
    return self;
}

- (id)objectFromSourceObject:(id)jsonObject error:(__autoreleasing NSError **)error {
    *error = nil;

    id object = [[self.classOfObjectToCreate alloc] init];
    for (id jsonKey in self.jsonKeysToFields) {
        id field = self.jsonKeysToFields[jsonKey];

        // note: this is an assumption here. We may not want to always use key path.
        id value = [jsonObject valueForKeyPath:jsonKey];
        id<Mapper> valueMapper = self.fieldsToMappers[field];
        if (valueMapper) {
            value = [valueMapper objectFromSourceObject:value error:error];

            if (*error) {
                return nil;
            }
        }

        if (value) { // setValue:forKey: fails if value is nil
            [object setValue:value forKey:field];
        }
    }
    return object;
}

@end
