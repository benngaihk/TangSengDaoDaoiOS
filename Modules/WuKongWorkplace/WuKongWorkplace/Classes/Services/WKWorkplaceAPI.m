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
#import <PromiseKit/PromiseKit.h>

@implementation WKWorkplaceAPI

+ (instancetype)sharedInstance {
    static WKWorkplaceAPI *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WKWorkplaceAPI alloc] init];
    });
    return instance;
}

#pragma mark - 应用管理

- (AnyPromise *)getUserApps {
    return [[WKAPIClient sharedClient] GET:@"workplace/app" parameters:nil].then(^(id responseObject) {
        NSMutableArray *apps = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    WKWorkplaceApp *app = [WKWorkplaceApp fromMap:dict type:ModelMapTypeAPI];
                    if (app) {
                        [apps addObject:app];
                    }
                }
            }
        }
        return apps;
    });
}

- (AnyPromise *)addApp:(NSString *)appId {
    NSString *path = [NSString stringWithFormat:@"workplace/apps/%@", appId];
    return [[WKAPIClient sharedClient] POST:path parameters:nil];
}

- (AnyPromise *)removeApp:(NSString *)appId {
    NSString *path = [NSString stringWithFormat:@"workplace/apps/%@", appId];
    return [[WKAPIClient sharedClient] DELETE:path parameters:nil];
}

- (AnyPromise *)reorderApps:(NSArray<NSString *> *)appIds {
    NSDictionary *parameters = @{@"app_ids": appIds};
    return [[WKAPIClient sharedClient] PUT:@"workplace/app/reorder" parameters:parameters];
}

#pragma mark - 常用应用

- (AnyPromise *)getFrequentApps {
    return [[WKAPIClient sharedClient] GET:@"workplace/app/record" parameters:nil].then(^(id responseObject) {
        NSMutableArray *apps = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    WKWorkplaceApp *app = [WKWorkplaceApp fromMap:dict type:ModelMapTypeAPI];
                    if (app) {
                        [apps addObject:app];
                    }
                }
            }
        }
        return apps;
    });
}

- (AnyPromise *)recordAppUsage:(NSString *)appId {
    NSString *path = [NSString stringWithFormat:@"workplace/apps/%@/record", appId];
    return [[WKAPIClient sharedClient] POST:path parameters:nil];
}

- (AnyPromise *)deleteAppRecord:(NSString *)appId {
    NSString *path = [NSString stringWithFormat:@"workplace/apps/%@/record", appId];
    return [[WKAPIClient sharedClient] DELETE:path parameters:nil];
}

#pragma mark - 分类管理

- (AnyPromise *)getCategories {
    return [[WKAPIClient sharedClient] GET:@"workplace/category" parameters:nil].then(^(id responseObject) {
        NSMutableArray *categories = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    WKWorkplaceCategory *category = [WKWorkplaceCategory fromMap:dict type:ModelMapTypeAPI];
                    if (category) {
                        [categories addObject:category];
                    }
                }
            }
        }
        return categories;
    });
}

- (AnyPromise *)getAppsInCategory:(NSString *)categoryNo {
    NSString *path = [NSString stringWithFormat:@"workplace/categorys/%@/app", categoryNo];
    return [[WKAPIClient sharedClient] GET:path parameters:nil].then(^(id responseObject) {
        NSMutableArray *apps = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    WKWorkplaceApp *app = [WKWorkplaceApp fromMap:dict type:ModelMapTypeAPI];
                    if (app) {
                        [apps addObject:app];
                    }
                }
            }
        }
        return apps;
    });
}

#pragma mark - 横幅管理

- (AnyPromise *)getBanners {
    return [[WKAPIClient sharedClient] GET:@"workplace/banner" parameters:nil].then(^(id responseObject) {
        NSMutableArray *banners = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    WKWorkplaceBanner *banner = [WKWorkplaceBanner fromMap:dict type:ModelMapTypeAPI];
                    if (banner) {
                        [banners addObject:banner];
                    }
                }
            }
        }
        return banners;
    });
}

@end 