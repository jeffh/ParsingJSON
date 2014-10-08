#import "PersonParser.h"
#import "Person.h"
#import "Mapper.h"
#import "StringToNumberMapper.h"
#import "ObjectMapper.h"
#import "ArrayMapper.h"
#import "ErrorMapper.h"
#import "JSONDataToObjectMapper.h"


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
    id<Mapper> friendMapper = [[ObjectMapper alloc] initWithGeneratorOfClass:[Person class]
                                                            jsonKeysToFields:@{@"id": @"identifier",
                                                                               @"name": @"name",
                                                                               @"height": @"height"}
                                                             fieldsToMappers:@{@"height": stringToNumberMapper}];
    id<Mapper> friendsMapper = [[ArrayMapper alloc] initWithItemMapper:friendMapper];

    NSDictionary *jsonKeysToFields = @{@"id": @"identifier",
                                       @"name": @"name",
                                       @"height": @"height",
                                       @"friends": @"friends"};
    NSDictionary *fieldsToMappers = @{@"height": stringToNumberMapper,
                                      @"friends": friendsMapper};
    id<Mapper> objectMapper = [[ObjectMapper alloc] initWithGeneratorOfClass:[Person class]
                                                            jsonKeysToFields:jsonKeysToFields
                                                             fieldsToMappers:fieldsToMappers];
    return [objectMapper objectFromSourceObject:json error:error];
}

- (id)jsonObjectFromJSONData:(NSData *)jsonData error:(__autoreleasing NSError **)error {
    JSONDataToObjectMapper *mapper = [[JSONDataToObjectMapper alloc] initWithErrorDomain:kParserErrorDomain
                                                                               errorCode:kParserErrorCodeBadData];
    return [mapper objectFromSourceObject:jsonData error:error];
}

- (NSError *)errorMessageFromJSON:(id)json {
    NSError *error = nil;
    ErrorMapper *errorMapper = [[ErrorMapper alloc] initWithErrorDomain:kParserErrorDomain
                                                              errorCode:kParserErrorCodeNotFound
                                                               userInfo:@{NSLocalizedDescriptionKey: @"No person was found"}
                                                   errorIfJSONKeyExists:@"message"];
    [errorMapper objectFromSourceObject:json error:&error];
    return error;
}

@end
