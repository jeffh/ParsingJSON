#import <Foundation/Foundation.h>


@class Person;
extern NSString *kParserErrorDomain;
extern NSInteger kParserErrorCodeNotFound;


@interface PersonParser : NSObject

- (Person *)personFromJSONData:(NSData *)jsonData error:(__autoreleasing NSError **)error;

@end
