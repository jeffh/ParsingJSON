#import <XCTest/XCTest.h>
#import <Cedar-iOS/Cedar-iOS.h>
#import "PersonParser.h"
#import "Person.h"
#import "Fixture.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(PersonParserSpec)

describe(@"PersonParser", ^{
    __block PersonParser *subject;

    beforeEach(^{
        subject = [[PersonParser alloc] init];
    });

    describe(@"converting JSON response to a Person object", ^{
        __block Person *person;
        __block NSData *data;

        // subjectAction runs after all beforeEaches for each it block
        subjectAction(^{
            person = [subject personFromJSONData:data];
        });

        context(@"with a valid JSON object of a person", ^{
            beforeEach(^{
                id json = @{@"id": @1,
                            @"name": @"Jeff Hui",
                            @"height": @70,
                            @"friends": @[@{@"id": @2, @"name": @"Andrew Kitchen", @"height": @86}]};
                data = [Fixture jsonDataFromObject:json];
            });

            it(@"should return a person", ^{
                person.identifier should equal(@1);
                person.name should equal(@"Jeff Hui");
                person.height should equal(70);
                person.friends.count should equal(1);
                Person *aFriend = person.friends.firstObject;
                aFriend.identifier should equal(@2);
                aFriend.name should equal(@"Andrew Kitchen");
                aFriend.height should equal(86);
            });
        });
    });
});

SPEC_END
