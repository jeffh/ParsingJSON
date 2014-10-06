#import <Foundation/Foundation.h>


@protocol Mapper <NSObject>

- (id)objectFromJSONObject:(id)jsonObject error:(__autoreleasing NSError **)error;

@end
