//
//  WKWorkplaceModule.m
//  WuKongWorkplace
//

#import "WKWorkplaceModule.h"
#import "WKWorkplaceAPI.h"
#import "WKWorkplaceVC.h"

@WKModule(WKWorkplaceModule)
@implementation WKWorkplaceModule

- (NSString *)moduleId {
    return @"WuKongWorkplace";
}

- (void)moduleInit:(WKModuleContext *)context {
    NSLog(@"【WuKongWorkplace】工作台模块初始化");
    
    // 注册获取用户应用接口
    [self setMethod:@"getUserApps" handler:^id _Nullable(id  _Nonnull param) {
        return [[WKWorkplaceAPI sharedInstance] getUserApps];
    }];
    
    // 注册添加应用接口
    [self setMethod:@"addApp" handler:^id _Nullable(id  _Nonnull param) {
        if ([param isKindOfClass:[NSString class]]) {
            return [[WKWorkplaceAPI sharedInstance] addApp:param];
        }
        return nil;
    }];
    
    // 注册移除应用接口
    [self setMethod:@"removeApp" handler:^id _Nullable(id  _Nonnull param) {
        if ([param isKindOfClass:[NSString class]]) {
            return [[WKWorkplaceAPI sharedInstance] removeApp:param];
        }
        return nil;
    }];
    
    // 注册应用排序接口
    [self setMethod:@"reorderApps" handler:^id _Nullable(id  _Nonnull param) {
        if ([param isKindOfClass:[NSArray class]]) {
            return [[WKWorkplaceAPI sharedInstance] reorderApps:param];
        }
        return nil;
    }];
    
    // 注册获取常用应用接口
    [self setMethod:@"getFrequentApps" handler:^id _Nullable(id  _Nonnull param) {
        return [[WKWorkplaceAPI sharedInstance] getFrequentApps];
    }];
    
    // 注册记录应用使用接口
    [self setMethod:@"recordAppUsage" handler:^id _Nullable(id  _Nonnull param) {
        if ([param isKindOfClass:[NSString class]]) {
            return [[WKWorkplaceAPI sharedInstance] recordAppUsage:param];
        }
        return nil;
    }];
    
    // 注册获取分类接口
    [self setMethod:@"getCategories" handler:^id _Nullable(id  _Nonnull param) {
        return [[WKWorkplaceAPI sharedInstance] getCategories];
    }];
    
    // 注册获取分类应用接口
    [self setMethod:@"getAppsByCategory" handler:^id _Nullable(id  _Nonnull param) {
        if ([param isKindOfClass:[NSString class]]) {
            return [[WKWorkplaceAPI sharedInstance] getAppsInCategory:param];
        }
        return nil;
    }];
    
    // 注册获取横幅接口
    [self setMethod:@"getBanners" handler:^id _Nullable(id  _Nonnull param) {
        return [[WKWorkplaceAPI sharedInstance] getBanners];
    }];
    
    // 注册工作台页面创建接口
    [self setMethod:@"createWorkplaceVC" handler:^id _Nullable(id  _Nonnull param) {
        return [[WKWorkplaceVC alloc] init];
    }];
}

@end 
