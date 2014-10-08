#import "StringToNumberMapper.h"

@implementation StringToNumberMapper

- (id)objectFromSourceObject:(id)jsonObject error:(__autoreleasing NSError **)error {
    // note: checking if jsonObject is the types we want might be useful
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *heightObject;
    if ([jsonObject isEqual:[NSNull null]]) {
        heightObject = @"";
    } else {
        heightObject = [jsonObject description];
    }
    return [formatter numberFromString:heightObject];
}

@end
