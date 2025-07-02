//
//  WKWorkplaceAPI.h
//  WuKongWorkplace
//
//  Created by AI on 2024/01/01.
//  Copyright © 2024 WuKongWorkplace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WuKongBase/WuKongBase.h>
#import <PromiseKit/PromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWorkplaceAPI : NSObject

/**
 * 获取用户添加的应用列表
 */
+ (AnyPromise *)getMyApps;

/**
 * 添加应用到工作台
 * @param appId 应用ID
 */
+ (AnyPromise *)addApp:(NSString *)appId;

/**
 * 从工作台移除应用
 * @param appId 应用ID
 */
+ (AnyPromise *)removeApp:(NSString *)appId;

/**
 * 应用排序
 * @param appIds 应用ID数组，按照期望的排序顺序排列
 */
+ (AnyPromise *)reorderApps:(NSArray<NSString *> *)appIds;

/**
 * 获取常用应用列表
 */
+ (AnyPromise *)getFrequentApps;

/**
 * 添加应用使用记录
 * @param appId 应用ID
 */
+ (AnyPromise *)addAppRecord:(NSString *)appId;

/**
 * 删除应用使用记录
 * @param appId 应用ID
 */
+ (AnyPromise *)deleteAppRecord:(NSString *)appId;

/**
 * 获取应用分类列表
 */
+ (AnyPromise *)getCategories;

/**
 * 获取分类下的应用
 * @param categoryNo 分类编号
 */
+ (AnyPromise *)getCategoryApps:(NSString *)categoryNo;

/**
 * 获取横幅列表
 */
+ (AnyPromise *)getBanners;

@end

NS_ASSUME_NONNULL_END 