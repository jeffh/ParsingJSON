#import "PersonParser.h"
#import "Person.h"
#import "Mapper.h"
#import "StringToNumberMapper.h"
#import "ObjectMapper.h"
#import "ArrayMapper.h"
#import "ErrorMapper.h"


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
    NSError *error = nil;
    ErrorMapper *errorMapper = [[ErrorMapper alloc] initWithErrorDomain:kParserErrorDomain
                                                              errorCode:kParserErrorCodeNotFound
                                                               userInfo:@{NSLocalizedDescriptionKey: @"No person was found"}
                                                   errorIfJSONKeyExists:@"message"];
    [errorMapper objectFromJSONObject:json error:&error];
    return error;
}

@end
