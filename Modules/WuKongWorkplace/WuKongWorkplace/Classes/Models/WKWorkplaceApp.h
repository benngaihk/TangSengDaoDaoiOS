//
//  WKWorkplaceApp.h
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import <Foundation/Foundation.h>
#import <WuKongBase/WuKongBase.h>

NS_ASSUME_NONNULL_BEGIN

/**
 工作台应用模型
 */
@interface WKWorkplaceApp : WKModel

/// 应用唯一ID
@property (nonatomic, copy) NSString *appId;

/// 排序号（数字越大越靠前）
@property (nonatomic, assign) NSInteger sortNum;

/// 应用图标URL
@property (nonatomic, copy) NSString *icon;

/// 应用名称
@property (nonatomic, copy) NSString *name;

/// 应用描述
@property (nonatomic, copy) NSString *appDescription;

/// 应用分类
@property (nonatomic, copy) NSString *appCategory;

/// 状态 (0=禁用, 1=启用)
@property (nonatomic, assign) NSInteger status;

/// 打开方式 (0=网页, 1=原生)
@property (nonatomic, assign) NSInteger jumpType;

/// 原生应用打开地址
@property (nonatomic, copy) NSString *appRoute;

/// 网页打开地址
@property (nonatomic, copy) NSString *webRoute;

/// 是否为付费应用 (0=否, 1=是)
@property (nonatomic, assign) NSInteger isPaidApp;

/// 是否已添加到工作台 (0=未添加, 1=已添加) - 仅在分类应用接口中使用
@property (nonatomic, assign) NSInteger isAdded;

/**
 从字典创建应用对象
 @param dict 字典数据
 @return 应用对象
 */
+ (instancetype)appWithDictionary:(NSDictionary *)dict;

/**
 转换为字典
 @return 字典数据
 */
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END 