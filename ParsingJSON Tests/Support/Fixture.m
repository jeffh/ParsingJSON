#import "Fixture.h"

@implementation Fixture

+ (NSData *)jsonDataFromObject:(id)jsonObject {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&error];
    NSAssert(error == nil, @"Failed to convert given object to JSON: %@", error);
    return data;
}

@end
