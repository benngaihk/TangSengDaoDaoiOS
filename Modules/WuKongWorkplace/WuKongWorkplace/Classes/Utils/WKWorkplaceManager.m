//
//  WKWorkplaceManager.m
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import "WKWorkplaceManager.h"
#import "WKWorkplaceAPI.h"
#import "WKWorkplaceApp.h"
#import "WKWorkplaceCategory.h"
#import "WKWorkplaceBanner.h"
#import <WuKongBase/WuKongBase.h>
#import <UIKit/UIKit.h>
#import <PromiseKit/PromiseKit.h>

@implementation WKWorkplaceManager

+ (instancetype)sharedManager {
    static WKWorkplaceManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[WKWorkplaceManager alloc] init];
    });
    return _sharedManager;
}

#pragma mark - 首页数据

- (AnyPromise *)loadHomeData {
    // 简化：只返回应用数据
    return [[WKWorkplaceAPI sharedInstance] getUserApps];
}

#pragma mark - 应用管理

- (AnyPromise *)addAppToWorkplace:(NSString *)appId {
    return [[WKWorkplaceAPI sharedInstance] addApp:appId];
}

- (AnyPromise *)removeAppFromWorkplace:(NSString *)appId {
    return [[WKWorkplaceAPI sharedInstance] removeApp:appId];
}

- (AnyPromise *)batchAddApps:(NSArray<NSString *> *)appIds {
    if (appIds.count == 0) {
        return [AnyPromise promiseWithValue:@YES];
    }
    
    // 简化：只添加第一个
    return [[WKWorkplaceAPI sharedInstance] addApp:appIds.firstObject];
}

- (AnyPromise *)batchRemoveApps:(NSArray<NSString *> *)appIds {
    if (appIds.count == 0) {
        return [AnyPromise promiseWithValue:@YES];
    }
    
    // 简化：只移除第一个
    return [[WKWorkplaceAPI sharedInstance] removeApp:appIds.firstObject];
}

- (AnyPromise *)reorderApps:(NSArray<NSString *> *)appIds {
    return [[WKWorkplaceAPI sharedInstance] reorderApps:appIds];
}

- (AnyPromise *)toggleApp:(WKWorkplaceApp *)app {
    if (app.isAdded) {
        // 如果已添加，则移除
        return [[WKWorkplaceAPI sharedInstance] removeApp:app.appId];
    } else {
        // 如果未添加，则添加
        return [[WKWorkplaceAPI sharedInstance] addApp:app.appId];
    }
}

#pragma mark - 应用使用

- (AnyPromise *)handleAppClick:(WKWorkplaceApp *)app {
    // 记录使用 + 跳转
    [self openApp:app];
    return [[WKWorkplaceAPI sharedInstance] recordAppUsage:app.appId];
}

- (void)openApp:(WKWorkplaceApp *)app {
    NSString *route = nil;
    
    if (app.jumpType == 1 && app.appRoute.length > 0) {
        // 原生跳转
        route = app.appRoute;
        [self openNativeRoute:route];
    } else if (app.webRoute.length > 0) {
        // 网页跳转
        route = app.webRoute;
        [self openWebRoute:route];
    }
}

- (void)openNativeRoute:(NSString *)route {
    // TODO: 实现原生路由跳转
    // 这里需要根据您的路由系统实现
    NSLog(@"Opening native route: %@", route);
}

- (void)openWebRoute:(NSString *)route {
    // TODO: 实现网页跳转
    // 这里需要根据您的网页展示方式实现
    NSLog(@"Opening web route: %@", route);
}

#pragma mark - 数据获取便捷方法

- (AnyPromise *)getUserApps {
    return [[WKWorkplaceAPI sharedInstance] getUserApps];
}

- (AnyPromise *)getFrequentApps {
    return [[WKWorkplaceAPI sharedInstance] getFrequentApps];
}

- (AnyPromise *)getCategories {
    return [[WKWorkplaceAPI sharedInstance] getCategories];
}

- (AnyPromise *)getAppsInCategory:(NSString *)categoryNo {
    return [[WKWorkplaceAPI sharedInstance] getAppsInCategory:categoryNo];
}

- (AnyPromise *)getBanners {
    return [[WKWorkplaceAPI sharedInstance] getBanners];
}

#pragma mark - UI Methods

- (void)handleAppClick:(WKWorkplaceApp *)app fromViewController:(UIViewController *)viewController {
    if (!app || !viewController) return;
    
    // 记录使用
    [[WKWorkplaceAPI sharedInstance] recordAppUsage:app.appId].catch(^(NSError *error) {
        // 忽略记录失败
    });
    
    // 跳转处理
    if (app.jumpType == 1 && app.appRoute.length > 0) {
        // 原生跳转
        NSURL *url = [NSURL URLWithString:app.appRoute];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else if (app.jumpType == 0 && app.webRoute.length > 0) {
        // 网页跳转
        [self openWebURL:app.webRoute fromViewController:viewController];
    }
}

- (void)handleBannerClick:(WKWorkplaceBanner *)banner fromViewController:(UIViewController *)viewController {
    if (!banner || !viewController) return;
    
    if (banner.jumpType == 1 && banner.route.length > 0) {
        // 原生跳转
        NSURL *url = [NSURL URLWithString:banner.route];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else if (banner.jumpType == 0 && banner.route.length > 0) {
        // 网页跳转
        [self openWebURL:banner.route fromViewController:viewController];
    }
}

- (void)openApp:(WKWorkplaceApp *)app fromViewController:(UIViewController *)viewController {
    if (app.jumpType == 1 && app.appRoute.length > 0) {
        // 原生跳转
        [self openNativeRoute:app.appRoute fromViewController:viewController];
    } else if (app.webRoute.length > 0) {
        // 网页跳转
        [self openWebRoute:app.webRoute fromViewController:viewController];
    }
}

- (void)openBanner:(WKWorkplaceBanner *)banner fromViewController:(UIViewController *)viewController {
    if (banner.jumpType == 1 && banner.route.length > 0) {
        // 原生跳转
        [self openNativeRoute:banner.route fromViewController:viewController];
    } else if (banner.route.length > 0) {
        // 网页跳转
        [self openWebRoute:banner.route fromViewController:viewController];
    }
}

- (void)openNativeRoute:(NSString *)route fromViewController:(UIViewController *)viewController {
    // TODO: 实现原生路由跳转（带视图控制器）
    // 这里需要根据您的路由系统实现
    NSLog(@"Opening native route from VC %@: %@", viewController, route);
    
    // 示例：可以通过通知或者路由系统跳转
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WKOpenNativeRoute" 
                                                        object:nil 
                                                      userInfo:@{@"route": route, @"viewController": viewController}];
}

- (void)openWebRoute:(NSString *)route fromViewController:(UIViewController *)viewController {
    // TODO: 实现网页跳转（带视图控制器）
    NSLog(@"Opening web route from VC %@: %@", viewController, route);
    
    // 示例：可以使用Safari或者内置WebView
    if (@available(iOS 9.0, *)) {
        NSURL *url = [NSURL URLWithString:route];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
}

- (void)openWebURL:(NSString *)urlString fromViewController:(UIViewController *)viewController {
    // 使用系统浏览器打开
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end 
