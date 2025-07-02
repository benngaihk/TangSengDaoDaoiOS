//
//  WKWorkplaceAPI.m
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import "WKWorkplaceAPI.h"
#import "WKWorkplaceApp.h"
#import "WKWorkplaceCategory.h"
#import "WKWorkplaceBanner.h"
#import <WuKongBase/WuKongBase.h>
#import <AFNetworking/AFNetworking.h>
#import <PromiseKit/PromiseKit.h>

@interface WKWorkplaceAPI ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation WKWorkplaceAPI

+ (instancetype)sharedInstance {
    static WKWorkplaceAPI *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKWorkplaceAPI alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSessionManager];
    }
    return self;
}

- (void)setupSessionManager {
    self.sessionManager = [AFHTTPSessionManager manager];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 设置超时时间
    self.sessionManager.requestSerializer.timeoutInterval = 30;
    
    // 自动设置Authorization头
    [self updateAuthorizationHeader];
}

- (void)updateAuthorizationHeader {
    // 这里应该从您的认证系统获取token
    // 暂时使用一个占位符，实际使用时请替换为真实的token获取逻辑
    NSString *token = [self getCurrentUserToken];
    if (token) {
        [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    }
}

- (NSString *)getCurrentUserToken {
    // TODO: 从您的认证系统获取当前用户token
    // 这里需要根据您的项目具体实现
    return nil;
}

#pragma mark - 应用管理

- (AnyPromise *)getUserApps {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self.sessionManager GET:@"/v1/workplace/app"
                       parameters:nil
                          headers:nil
                         progress:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
            NSMutableArray *apps = [NSMutableArray array];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responseObject) {
                    WKWorkplaceApp *app = [WKWorkplaceApp appWithDictionary:dict];
                    if (app) {
                        [apps addObject:app];
                    }
                }
            }
            resolve(apps);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)addApp:(NSString *)appId {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        NSString *path = [NSString stringWithFormat:@"/v1/workplace/apps/%@", appId];
        [self.sessionManager POST:path
                        parameters:nil
                           headers:nil
                          progress:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(@YES);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)removeApp:(NSString *)appId {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        NSString *path = [NSString stringWithFormat:@"/v1/workplace/apps/%@", appId];
        [self.sessionManager DELETE:path
                          parameters:nil
                             headers:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(@YES);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)reorderApps:(NSArray<NSString *> *)appIds {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        NSDictionary *parameters = @{@"app_ids": appIds};
        [self.sessionManager PUT:@"/v1/workplace/app/reorder"
                      parameters:parameters
                         headers:nil
                         success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(@YES);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

#pragma mark - 常用应用

- (AnyPromise *)getFrequentApps {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self.sessionManager GET:@"/v1/workplace/app/record"
                       parameters:nil
                          headers:nil
                         progress:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
            NSMutableArray *apps = [NSMutableArray array];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responseObject) {
                    WKWorkplaceApp *app = [WKWorkplaceApp appWithDictionary:dict];
                    if (app) {
                        [apps addObject:app];
                    }
                }
            }
            resolve(apps);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)recordAppUsage:(NSString *)appId {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        NSString *path = [NSString stringWithFormat:@"/v1/workplace/apps/%@/record", appId];
        [self.sessionManager POST:path
                        parameters:nil
                           headers:nil
                          progress:nil
                           success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(@YES);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)deleteAppRecord:(NSString *)appId {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        NSString *path = [NSString stringWithFormat:@"/v1/workplace/apps/%@/record", appId];
        [self.sessionManager DELETE:path
                          parameters:nil
                             headers:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
            resolve(@YES);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

#pragma mark - 分类管理

- (AnyPromise *)getCategories {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self.sessionManager GET:@"/v1/workplace/category"
                       parameters:nil
                          headers:nil
                         progress:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
            NSMutableArray *categories = [NSMutableArray array];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responseObject) {
                    WKWorkplaceCategory *category = [WKWorkplaceCategory categoryWithDictionary:dict];
                    if (category) {
                        [categories addObject:category];
                    }
                }
            }
            resolve(categories);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

- (AnyPromise *)getAppsInCategory:(NSString *)categoryNo {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        NSString *path = [NSString stringWithFormat:@"/v1/workplace/categorys/%@/app", categoryNo];
        [self.sessionManager GET:path
                       parameters:nil
                          headers:nil
                         progress:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
            NSMutableArray *apps = [NSMutableArray array];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responseObject) {
                    WKWorkplaceApp *app = [WKWorkplaceApp appWithDictionary:dict];
                    if (app) {
                        [apps addObject:app];
                    }
                }
            }
            resolve(apps);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

#pragma mark - 横幅管理

- (AnyPromise *)getBanners {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [self.sessionManager GET:@"/v1/workplace/banner"
                       parameters:nil
                          headers:nil
                         progress:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
            NSMutableArray *banners = [NSMutableArray array];
            if ([responseObject isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in responseObject) {
                    WKWorkplaceBanner *banner = [WKWorkplaceBanner bannerWithDictionary:dict];
                    if (banner) {
                        [banners addObject:banner];
                    }
                }
            }
            resolve(banners);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            resolve(error);
        }];
    }];
}

@end 