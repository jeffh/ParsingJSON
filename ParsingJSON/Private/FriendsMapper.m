#import "FriendsMapper.h"
#import "ObjectMapper.h"
#import "StringToNumberMapper.h"
#import "Person.h"


// This class exists as purely conformance to the mapper protocol for ObjectMapper.
// We need to refactor this.
@implementation FriendsMapper

- (id)objectFromJSONObject:(id)jsonObject error:(__autoreleasing NSError **)error {
    id<Mapper> stringToNumberMapper = [[StringToNumberMapper alloc] init];
    id<Mapper> objectMapper = [[ObjectMapper alloc] initWithGeneratorOfClass:[Person class]
                                                            jsonKeysToFields:@{@"id": @"identifier",
                                                                               @"name": @"name",
                                                                               @"height": @"height"}
                                                             fieldsToMappers:@{@"height": stringToNumberMapper}];
    *error = nil;

    NSMutableArray *friends = [NSMutableArray array];
    for (NSDictionary *friendDict in jsonObject) {
        id object = [objectMapper objectFromJSONObject:friendDict error:error];
        if (*error) {
            return nil;
        }
        [friends addObject:object];
    }
    return friends;
}

@end
