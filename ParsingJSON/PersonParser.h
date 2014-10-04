#import <Foundation/Foundation.h>


@class Person;


@interface PersonParser : NSObject

- (Person *)personFromJSONData:(NSData *)jsonData;

@end
