#import "JSONDataToObjectMapper.h"

@interface JSONDataToObjectMapper ()
@property (nonatomic, copy) NSString *errorDomain;
@property (nonatomic) NSInteger errorCode;
@end

@implementation JSONDataToObjectMapper

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return self;
}

- (instancetype)initWithErrorDomain:(NSString *)errorDomain
                          errorCode:(NSInteger)errorCode {
    if (self = [super init]) {
        self.errorDomain = errorDomain;
        self.errorCode = errorCode;
    }
    return self;
}

- (id)objectFromSourceObject:(id)jsonObject error:(__autoreleasing NSError **)error {
    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:jsonObject options:0 error:&jsonError];

    if (jsonError) {
        *error = [NSError errorWithDomain:self.errorDomain
                                     code:self.errorCode
                                 userInfo:@{NSUnderlyingErrorKey: jsonError}];
        return nil;
    }
    return json;
}

@end
