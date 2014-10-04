#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic) id identifier;
@property (nonatomic) NSString *name;
@property (nonatomic) NSUInteger height;
@property (nonatomic) NSArray *friends;

@end
