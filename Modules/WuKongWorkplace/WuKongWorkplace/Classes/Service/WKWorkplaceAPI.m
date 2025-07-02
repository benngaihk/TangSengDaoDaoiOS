//
//  WKWorkplaceAPI.m
//  WuKongWorkplace
//
//  Created by AI on 2024/01/01.
//  Copyright © 2024 WuKongWorkplace. All rights reserved.
//

#import "WKWorkplaceAPI.h"

@implementation WKWorkplaceAPI

#pragma mark - 应用管理

+ (AnyPromise *)getMyApps {
    return [[WKAPIClient sharedClient] GET:@"workplace/app" parameters:nil];
}

+ (AnyPromise *)addApp:(NSString *)appId {
    NSString *path = [NSString stringWithFormat:@"workplace/apps/%@", appId];
    return [[WKAPIClient sharedClient] POST:path parameters:nil];
}

+ (AnyPromise *)removeApp:(NSString *)appId {
    NSString *path = [NSString stringWithFormat:@"workplace/apps/%@", appId];
    return [[WKAPIClient sharedClient] DELETE:path parameters:nil];
}

+ (AnyPromise *)reorderApps:(NSArray<NSString *> *)appIds {
    NSDictionary *params = @{@"app_ids": appIds};
    return [[WKAPIClient sharedClient] PUT:@"workplace/app/reorder" parameters:params];
}

#pragma mark - 常用应用

+ (AnyPromise *)getFrequentApps {
    return [[WKAPIClient sharedClient] GET:@"workplace/app/record" parameters:nil];
}

+ (AnyPromise *)addAppRecord:(NSString *)appId {
    NSString *path = [NSString stringWithFormat:@"workplace/apps/%@/record", appId];
    return [[WKAPIClient sharedClient] POST:path parameters:nil];
}

+ (AnyPromise *)deleteAppRecord:(NSString *)appId {
    NSString *path = [NSString stringWithFormat:@"workplace/apps/%@/record", appId];
    return [[WKAPIClient sharedClient] DELETE:path parameters:nil];
}

#pragma mark - 分类管理

+ (AnyPromise *)getCategories {
    return [[WKAPIClient sharedClient] GET:@"workplace/category" parameters:nil];
}

+ (AnyPromise *)getCategoryApps:(NSString *)categoryNo {
    NSString *path = [NSString stringWithFormat:@"workplace/categorys/%@/app", categoryNo];
    return [[WKAPIClient sharedClient] GET:path parameters:nil];
}

#pragma mark - 横幅管理

+ (AnyPromise *)getBanners {
    return [[WKAPIClient sharedClient] GET:@"workplace/banner" parameters:nil];
}

@end 