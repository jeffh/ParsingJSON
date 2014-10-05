#import "PersonParser.h"
#import "Person.h"


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
    Person *person = [[Person alloc] init];
    person.identifier = json[@"id"];
    person.name = json[@"name"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *heightObject;
    if ([json[@"height"] isEqual:[NSNull null]]) {
        heightObject = @"";
    } else {
        heightObject = [json[@"height"] description];
    }
    person.height = [[formatter numberFromString:heightObject] unsignedIntegerValue];
    person.friends = [self friendsWithJSON:json];
    return person;
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

- (NSArray *)friendsWithJSON:(id)jsonObject {
    NSMutableArray *friends = [NSMutableArray array];
    for (NSDictionary *friendDict in jsonObject[@"friends"]) {
        [friends addObject:[self personFromJSONObject:friendDict error:nil]];
    }
    return friends;
}

@end
