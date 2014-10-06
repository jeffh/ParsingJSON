#import "PersonParser.h"
#import "Person.h"
#import "Mapper.h"
#import "StringToNumberMapper.h"
#import "ObjectMapper.h"
#import "FriendsMapper.h"


NSString *kParserErrorDomain = @"kParserErrorDomain";
NSInteger kParserErrorCodeNotFound = 1;
NSInteger kParserErrorCodeBadData = 2;


@implementation PersonParser

#pragma mark - Public

- (Person *)personFromJSONData:(NSData *)jsonData error:(__autoreleasing NSError **)error {
    *error = nil;

    id json = [self jsonObjectFromJSONData:jsonData error:error];
    if (*error) {
        return nil;
    }
    *error = [self errorMessageFromJSON:json];
    if (*error) {
        return nil;
    }

    return [self personFromJSONObject:json error:error];
}

#pragma mark - Private

- (Person *)personFromJSONObject:(id)json error:(__autoreleasing NSError **)error {
    id<Mapper> stringToNumberMapper = [[StringToNumberMapper alloc] init];
    id<Mapper> friendsMapper = [[FriendsMapper alloc] init];
    id<Mapper> objectMapper = [[ObjectMapper alloc] initWithGeneratorOfClass:[Person class]
                                                            jsonKeysToFields:@{@"id": @"identifier",
                                                                               @"name": @"name",
                                                                               @"height": @"height",
                                                                               @"friends": @"friends"}
                                                             fieldsToMappers:@{@"height": stringToNumberMapper,
                                                                               @"friends": friendsMapper}];
    return [objectMapper objectFromJSONObject:json error:error];
}

- (id)jsonObjectFromJSONData:(NSData *)jsonData error:(__autoreleasing NSError **)error {
    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];

    if (jsonError) {
        *error = [NSError errorWithDomain:kParserErrorDomain
                                     code:kParserErrorCodeBadData
                                 userInfo:@{NSUnderlyingErrorKey: jsonError}];
        return nil;
    }
    return json;
}

- (NSError *)errorMessageFromJSON:(id)json {
    if (json[@"message"]) {
        return [NSError errorWithDomain:kParserErrorDomain
                                   code:kParserErrorCodeNotFound
                               userInfo:@{NSLocalizedDescriptionKey: @"No person was found"}];
    }
    return nil;
}

@end
