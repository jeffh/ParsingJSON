#import <Foundation/Foundation.h>


@protocol Mapper <NSObject>

- (id)objectFromSourceObject:(id)jsonObject error:(__autoreleasing NSError **)error;

@end
