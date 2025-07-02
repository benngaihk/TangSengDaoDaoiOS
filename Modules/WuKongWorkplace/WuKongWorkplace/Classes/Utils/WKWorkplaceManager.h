//
//  WKWorkplaceManager.h
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import <Foundation/Foundation.h>
#import <WuKongBase/WuKongBase.h>
#import <PromiseKit/PromiseKit.h>
#import "WKWorkplaceApp.h"
#import "WKWorkplaceCategory.h"
#import "WKWorkplaceBanner.h"

@class AnyPromise;
@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 * 工作台业务管理器
 * 提供简化的业务接口和自动化处理
 */
@interface WKWorkplaceManager : NSObject

/**
 * 单例实例
 */
+ (instancetype)sharedManager;

#pragma mark - 首页数据

/**
 * 获取首页数据（横幅 + 应用）
 * @return Promise<NSDictionary *> {banners: NSArray, apps: NSArray}
 */
- (AnyPromise *)loadHomeData;

#pragma mark - 应用管理

/**
 * 添加应用到工作台
 * @param appId 应用ID
 * @return Promise<NSNumber *>
 */
- (AnyPromise *)addAppToWorkplace:(NSString *)appId;

/**
 * 从工作台移除应用
 * @param appId 应用ID
 * @return Promise<NSNumber *>
 */
- (AnyPromise *)removeAppFromWorkplace:(NSString *)appId;

/**
 * 批量添加应用
 * @param appIds 应用ID数组
 * @return Promise<NSNumber *>
 */
- (AnyPromise *)batchAddApps:(NSArray<NSString *> *)appIds;

/**
 * 批量移除应用
 * @param appIds 应用ID数组
 * @return Promise<NSNumber *>
 */
- (AnyPromise *)batchRemoveApps:(NSArray<NSString *> *)appIds;

/**
 * 重新排序应用
 * @param appIds 应用ID数组，按期望顺序排列
 * @return Promise<NSNumber *>
 */
- (AnyPromise *)reorderApps:(NSArray<NSString *> *)appIds;

/**
 * 切换应用状态（添加/移除）
 * @param app 应用对象
 * @return Promise<NSNumber *>
 */
- (AnyPromise *)toggleApp:(WKWorkplaceApp *)app;

#pragma mark - 应用使用

/**
 * 处理应用点击（记录使用 + 跳转）
 * @param app 应用对象
 * @return Promise<NSNumber *>
 */
- (AnyPromise *)handleAppClick:(WKWorkplaceApp *)app;

/**
 * 处理应用点击（记录使用 + 跳转）- UI版本
 * @param app 应用对象
 * @param viewController 当前视图控制器
 */
- (void)handleAppClick:(WKWorkplaceApp *)app fromViewController:(UIViewController *)viewController;

/**
 * 处理横幅点击
 * @param banner 横幅对象
 * @param viewController 当前视图控制器
 */
- (void)handleBannerClick:(WKWorkplaceBanner *)banner fromViewController:(UIViewController *)viewController;

/**
 * 打开应用
 * @param app 应用对象
 */
- (void)openApp:(WKWorkplaceApp *)app;

/**
 * 打开应用 - UI版本
 * @param app 应用对象
 * @param viewController 当前视图控制器
 */
- (void)openApp:(WKWorkplaceApp *)app fromViewController:(UIViewController *)viewController;

/**
 * 打开横幅
 * @param banner 横幅对象
 * @param viewController 当前视图控制器
 */
- (void)openBanner:(WKWorkplaceBanner *)banner fromViewController:(UIViewController *)viewController;

#pragma mark - 数据获取便捷方法

/**
 * 获取用户应用列表
 * @return Promise<NSArray<WKWorkplaceApp *> *>
 */
- (AnyPromise *)getUserApps;

/**
 * 获取常用应用列表
 * @return Promise<NSArray<WKWorkplaceApp *> *>
 */
- (AnyPromise *)getFrequentApps;

/**
 * 获取分类列表
 * @return Promise<NSArray<WKWorkplaceCategory *> *>
 */
- (AnyPromise *)getCategories;

/**
 * 获取分类下的应用
 * @param categoryNo 分类编号
 * @return Promise<NSArray<WKWorkplaceApp *> *>
 */
- (AnyPromise *)getAppsInCategory:(NSString *)categoryNo;

/**
 * 获取横幅列表
 * @return Promise<NSArray<WKWorkplaceBanner *> *>
 */
- (AnyPromise *)getBanners;

@end

NS_ASSUME_NONNULL_END 