#import "PersonParser.h"
#import "Person.h"
#import "Mapper.h"
#import "StringToNumberMapper.h"
#import "ObjectMapper.h"
#import "ArrayMapper.h"
#import "ErrorIfMapper.h"
#import "JSONDataToObjectMapper.h"
#import "ChainMapper.h"
#import "OptionalMapper.h"
#import "NonNilMapper.h"


NSString *kParserErrorDomain = @"kParserErrorDomain";
NSInteger kParserErrorCodeNotFound = 1;
NSInteger kParserErrorCodeBadData = 2;


@implementation PersonParser

#pragma mark - Public

- (Person *)personFromJSONData:(NSData *)jsonData error:(__autoreleasing NSError **)error {
    JSONDataToObjectMapper *jsonMapper = [[JSONDataToObjectMapper alloc] initWithErrorDomain:kParserErrorDomain
                                                                                   errorCode:kParserErrorCodeBadData];
    ErrorIfMapper *errorMapper = [[ErrorIfMapper alloc] initWithErrorDomain:kParserErrorDomain
                                                                  errorCode:kParserErrorCodeNotFound
                                                                   userInfo:@{NSLocalizedDescriptionKey: @"No person was found"}
                                                       errorIfJSONKeyExists:@"message"];

    NSArray *mappersToTry = @[jsonMapper, errorMapper, [self personMapper]];
    ChainMapper *mapper = [[ChainMapper alloc] initWithMappers:mappersToTry];
    return [mapper objectFromSourceObject:jsonData error:error];
}

#pragma mark - Private

- (id<Mapper>)personMapper {
    id<Mapper> stringToNumber = [[StringToNumberMapper alloc] init];
    id<Mapper> required = [[NonNilMapper alloc] initWithErrorDomain:kParserErrorDomain
                                                                errorCode:kParserErrorCodeNotFound
                                                                 userInfo:@{}];
    id<Mapper> friendMapper = [[ObjectMapper alloc] initWithGeneratorOfClass:[Person class]
                                                            jsonKeysToFields:@{@"id": @"identifier",
                                                                               @"name": @"name",
                                                                               @"height": @"height"}
                                                             fieldsToMappers:@{@"height": stringToNumber,
                                                                               @"id": required,
                                                                               @"name": required}];
    id<Mapper> objectToFriendOrEmpty = [[OptionalMapper alloc] initWithMapper:friendMapper];
    id<Mapper> objectToFriends = [[ArrayMapper alloc] initWithItemMapper:objectToFriendOrEmpty];

    NSDictionary *jsonKeysToFields = @{@"id": @"identifier",
                                       @"name": @"name",
                                       @"height": @"height",
                                       @"friends": @"friends"};
    NSDictionary *fieldsToMappers = @{@"height": stringToNumber,
                                      @"friends": objectToFriends};
    id<Mapper> objectMapper = [[ObjectMapper alloc] initWithGeneratorOfClass:[Person class]
                                                            jsonKeysToFields:jsonKeysToFields
                                                             fieldsToMappers:fieldsToMappers];
    return objectMapper;
}

@end
