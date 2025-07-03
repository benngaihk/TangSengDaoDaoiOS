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

// 为导航控制器添加隐藏返回按钮的扩展方法
@interface UINavigationController (HideBackButton)
- (void)hideBackButtonForMiniProgramStyle;
@end

@implementation UINavigationController (HideBackButton)
- (void)hideBackButtonForMiniProgramStyle {
    // 隐藏所有返回按钮
    self.navigationBar.backIndicatorImage = [UIImage new];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage new];
    self.topViewController.navigationItem.hidesBackButton = YES;
    self.topViewController.navigationItem.leftBarButtonItem = nil;
    self.topViewController.navigationItem.leftBarButtonItems = nil;
}
@end

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
    // 先获取应用数据，然后获取横幅数据
    return [[WKWorkplaceAPI sharedInstance] getUserApps].then(^(NSArray *apps) {
        // 获取横幅数据
        return [[WKWorkplaceAPI sharedInstance] getBanners].then(^(NSArray *banners) {
            return @{
                @"banners": banners ?: @[],
                @"apps": apps ?: @[]
            };
        }).catch(^(NSError *error) {
            // 横幅获取失败时，至少返回应用数据
            NSLog(@"获取横幅数据失败: %@", error.localizedDescription);
            return @{
                @"banners": @[],
                @"apps": apps ?: @[]
            };
        });
    }).catch(^(NSError *error) {
        // 如果连应用数据都获取失败，返回空数据
        NSLog(@"加载工作台数据失败: %@", error.localizedDescription);
        return @{
            @"banners": @[],
            @"apps": @[]
        };
    });
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
    // 获取当前顶层视图控制器
    UIViewController *topViewController = [self topViewController];
    
    if (app.jumpType == 1 && app.appRoute.length > 0) {
        // 原生跳转
        [self openNativeRoute:app.appRoute fromViewController:topViewController];
    } else if (app.webRoute.length > 0) {
        // 网页跳转
        [self openWebURL:app.webRoute fromViewController:topViewController];
    }
}

// 获取当前顶层视图控制器的工具方法
- (UIViewController *)topViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if ([topController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)topController;
        return navController.visibleViewController;
    } else if ([topController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)topController;
        if ([tabController.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)tabController.selectedViewController;
            return navController.visibleViewController;
        } else {
            return tabController.selectedViewController;
        }
    }
    
    return topController;
}



- (void)openWebRoute:(NSString *)route fromViewController:(UIViewController *)viewController {
    NSLog(@"Opening web route from VC %@: %@", viewController, route);
    
    // 使用缓存机制创建WebView，相同URL不会重复加载
    NSURL *url = [NSURL URLWithString:route];
    WKWebViewVC *webVC = [WKWebViewVC cachedWebViewWithURL:url];
    webVC.title = @"唐僧叨叨"; // 使用应用名称作为标题
    
    // 通过导航控制器推入WebView（小程序风格会自动隐藏TabBar）
    if (viewController.navigationController) {
        [viewController.navigationController pushViewController:webVC animated:YES];
        // 使用扩展方法隐藏返回按钮
        [viewController.navigationController hideBackButtonForMiniProgramStyle];
    } else {
        // 如果当前控制器没有导航控制器，创建一个新的导航控制器
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webVC];
        navController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        // 使用扩展方法隐藏返回按钮
        [navController hideBackButtonForMiniProgramStyle];
        
        [viewController presentViewController:navController animated:YES completion:nil];
    }
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

- (void)openWebURL:(NSString *)urlString fromViewController:(UIViewController *)viewController {
    // 使用缓存机制创建WebView，相同URL不会重复加载
    NSURL *url = [NSURL URLWithString:urlString];
    WKWebViewVC *webVC = [WKWebViewVC cachedWebViewWithURL:url];
    webVC.title = @"唐僧叨叨"; // 使用应用名称作为标题
    
    // 通过导航控制器推入WebView（小程序风格会自动隐藏TabBar）
    if (viewController.navigationController) {
        [viewController.navigationController pushViewController:webVC animated:YES];
        // 使用扩展方法隐藏返回按钮
        [viewController.navigationController hideBackButtonForMiniProgramStyle];
    } else {
        // 如果当前控制器没有导航控制器，创建一个新的导航控制器
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webVC];
        navController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        // 使用扩展方法隐藏返回按钮
        [navController hideBackButtonForMiniProgramStyle];
        
        [viewController presentViewController:navController animated:YES completion:nil];
    }
}



@end 
