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
        __block NSError *error;

        // subjectAction runs after all beforeEaches for each it block
        subjectAction(^{
            person = [subject personFromJSONData:data error:&error];
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

            it(@"should return no error", ^{
                error should be_nil;
            });
        });

        context(@"when a valid JSON object that has heights as nulls", ^{
            beforeEach(^{
                id json = @{@"id": @1,
                            @"name": @"Jeff Hui",
                            @"height": [NSNull null],
                            @"friends": @[@{@"id": @2, @"name": @"Andrew Kitchen", @"height": [NSNull null]}]};
                data = [Fixture jsonDataFromObject:json];
            });

            it(@"should return a person", ^{
                person.identifier should equal(@1);
                person.name should equal(@"Jeff Hui");
                person.height should equal(0);
                person.friends.count should equal(1);
                Person *aFriend = person.friends.firstObject;
                aFriend.identifier should equal(@2);
                aFriend.name should equal(@"Andrew Kitchen");
                aFriend.height should equal(0);
            });

            it(@"should return no error", ^{
                error should be_nil;
            });
        });

        context(@"with a valid JSON object that has heights as strings", ^{
            beforeEach(^{
                id json = @{@"id": @1,
                            @"name": @"Jeff Hui",
                            @"height": @"70",
                            @"friends": @[@{@"id": @2, @"name": @"Andrew Kitchen", @"height": @"86"}]};
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

            it(@"should return no error", ^{
                error should be_nil;
            });
        });

        context(@"with a valid JSON object of an error", ^{
            beforeEach(^{
                id json = @{@"message": @"Person not found"};
                data = [Fixture jsonDataFromObject:json];
            });

            it(@"should return nil", ^{
                person should be_nil;
            });

            it(@"should return an error indicating no person was given", ^{
                error.domain should equal(kParserErrorDomain);
                error.code should equal(kParserErrorCodeNotFound);
                error.userInfo should equal(@{NSLocalizedDescriptionKey: @"No person was found"});
            });
        });

        context(@"with an invalid JSON object", ^{
            __block NSError *jsonParseError;
            beforeEach(^{
                data = [@"invalid" dataUsingEncoding:NSUTF8StringEncoding];
                jsonParseError = nil;
                [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParseError];
                jsonParseError should_not be_nil; // make sure we got the error.
            });

            it(@"should return nil", ^{
                person should be_nil;
            });

            it(@"should return an error indicating the JSON failed to parse", ^{
                error.domain should equal(kParserErrorDomain);
                error.code should equal(kParserErrorCodeBadData);
                error.userInfo should equal(@{NSUnderlyingErrorKey: jsonParseError});
            });
        });
    });
});

SPEC_END
