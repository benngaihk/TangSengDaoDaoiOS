//
//  WKWorkplaceAPI.h
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WKWorkplaceApp.h"
#import "WKWorkplaceCategory.h"
#import "WKWorkplaceBanner.h"

@class AnyPromise;

NS_ASSUME_NONNULL_BEGIN

/**
 * 工作台API服务
 * 提供工作台相关的网络接口调用
 */
@interface WKWorkplaceAPI : NSObject

/**
 * 单例实例
 */
+ (instancetype)sharedInstance;

#pragma mark - 应用管理

/**
 * 获取用户已添加的应用列表
 * @return Promise<NSArray<WKWorkplaceApp *> *>
 */
- (AnyPromise *)getUserApps;

/**
 * 添加应用到工作台
 * @param appId 应用ID
 * @return Promise<NSNumber *> 操作结果
 */
- (AnyPromise *)addApp:(NSString *)appId;

/**
 * 从工作台移除应用
 * @param appId 应用ID
 * @return Promise<NSNumber *> 操作结果
 */
- (AnyPromise *)removeApp:(NSString *)appId;

/**
 * 重新排序应用
 * @param appIds 应用ID数组，按期望顺序排列
 * @return Promise<NSNumber *> 操作结果
 */
- (AnyPromise *)reorderApps:(NSArray<NSString *> *)appIds;

#pragma mark - 常用应用

/**
 * 获取常用应用列表
 * @return Promise<NSArray<WKWorkplaceApp *> *>
 */
- (AnyPromise *)getFrequentApps;

/**
 * 记录应用使用
 * @param appId 应用ID
 * @return Promise<NSNumber *> 操作结果
 */
- (AnyPromise *)recordAppUsage:(NSString *)appId;

/**
 * 删除应用使用记录
 * @param appId 应用ID
 * @return Promise<NSNumber *> 操作结果
 */
- (AnyPromise *)deleteAppRecord:(NSString *)appId;

#pragma mark - 分类管理

/**
 * 获取应用分类列表
 * @return Promise<NSArray<WKWorkplaceCategory *> *>
 */
- (AnyPromise *)getCategories;

/**
 * 获取指定分类下的应用
 * @param categoryNo 分类编号
 * @return Promise<NSArray<WKWorkplaceApp *> *>
 */
- (AnyPromise *)getAppsInCategory:(NSString *)categoryNo;

#pragma mark - 横幅管理

/**
 * 获取横幅列表
 * @return Promise<NSArray<WKWorkplaceBanner *> *>
 */
- (AnyPromise *)getBanners;

@end

NS_ASSUME_NONNULL_END 