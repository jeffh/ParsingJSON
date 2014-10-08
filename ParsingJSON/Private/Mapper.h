#import <Foundation/Foundation.h>

extern NSString *kIsNonFatalKey;

@protocol Mapper <NSObject>

- (id)objectFromSourceObject:(id)jsonObject error:(__autoreleasing NSError **)error;

@end
