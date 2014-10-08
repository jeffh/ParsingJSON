#import "NonNilMapper.h"

@interface NonNilMapper ()
@property (nonatomic, copy) NSString *errorDomain;
@property (nonatomic) NSInteger errorCode;
@property (nonatomic, copy) NSDictionary *userInfo;
@end

@implementation NonNilMapper

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithErrorDomain:(NSString *)errorDomain
                          errorCode:(NSInteger)errorCode
                           userInfo:(NSDictionary *)userInfo {
    if (self = [super init]) {
        self.errorDomain = errorDomain;
        self.errorCode = errorCode;
        self.userInfo = userInfo;
    }
    return self;
}

- (id)objectFromSourceObject:(id)jsonObject error:(__autoreleasing NSError **)error {
    if (!jsonObject) {
        *error = [NSError errorWithDomain:self.errorDomain
                                     code:self.errorCode
                                 userInfo:self.userInfo];
    }
    return jsonObject;
}

@end
