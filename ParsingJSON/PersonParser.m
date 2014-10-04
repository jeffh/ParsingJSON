#import "PersonParser.h"
#import "Person.h"


@implementation PersonParser

- (Person *)personFromJSONData:(NSData *)jsonData  {
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    Person *person = [[Person alloc] init];
    person.identifier = json[@"id"];
    person.name = json[@"name"];
    person.height = [json[@"height"] unsignedIntegerValue];

    NSMutableArray *friends = [NSMutableArray array];
    for (NSDictionary *friendDict in json[@"friends"]) {
        Person *aFriend = [[Person alloc] init];
        aFriend.identifier = friendDict[@"id"];
        aFriend.name = friendDict[@"name"];
        aFriend.height = [friendDict[@"height"] integerValue];
        [friends addObject:aFriend];
    }
    person.friends = friends;
    return person;
}

@end
