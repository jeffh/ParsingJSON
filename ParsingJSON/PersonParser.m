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
    person.friends = [self friendsWithJSON:json formatter:formatter];
    return person;
}

#pragma mark - Private

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

- (NSArray *)friendsWithJSON:(id)jsonObject formatter:(NSNumberFormatter *)formatter {
    NSMutableArray *friends = [NSMutableArray array];
    for (NSDictionary *friendDict in jsonObject[@"friends"]) {
        Person *aFriend = [[Person alloc] init];
        aFriend.identifier = friendDict[@"id"];
        aFriend.name = friendDict[@"name"];

        NSString *heightObject;
        if ([jsonObject[@"height"] isEqual:[NSNull null]]) {
            heightObject = @"";
        } else {
            heightObject = [friendDict[@"height"] description];
        }
        aFriend.height = [[formatter numberFromString:heightObject] unsignedIntegerValue];
        
        [friends addObject:aFriend];
    }
    return friends;
}

@end
