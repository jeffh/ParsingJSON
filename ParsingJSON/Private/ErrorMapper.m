#import "ErrorMapper.h"

@interface ErrorMapper ()
@property (nonatomic, copy) NSString *errorDomain;
@property (nonatomic) NSInteger errorCode;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, copy) NSString *jsonKey;
@end

@implementation ErrorMapper

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return self;
}

- (instancetype)initWithErrorDomain:(NSString *)errorDomain
                          errorCode:(NSInteger)errorCode
                           userInfo:(NSDictionary *)userInfo
               errorIfJSONKeyExists:(NSString *)jsonKey {
    if (self = [super init]) {
        self.errorDomain = errorDomain;
        self.errorCode = errorCode;
        self.userInfo = userInfo;
        self.jsonKey = jsonKey;
    }
    return self;
}

- (id)objectFromJSONObject:(id)jsonObject error:(__autoreleasing NSError **)error {
    if (jsonObject[self.jsonKey]) {
        *error = [NSError errorWithDomain:self.errorDomain
                                     code:self.errorCode
                                 userInfo:self.userInfo];
    }
    return nil;
}

@end
