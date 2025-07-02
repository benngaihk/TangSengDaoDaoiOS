//
//  WKWorkplaceCategory.h
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import <Foundation/Foundation.h>
#import <WuKongBase/WuKongBase.h>

NS_ASSUME_NONNULL_BEGIN

/**
 工作台分类模型
 */
@interface WKWorkplaceCategory : WKModel

/// 分类编号
@property (nonatomic, copy) NSString *categoryNo;

/// 分类名称
@property (nonatomic, copy) NSString *name;

/// 排序号（数字越大越靠前）
@property (nonatomic, assign) NSInteger sortNum;

/**
 从字典创建分类对象
 @param dict 字典数据
 @return 分类对象
 */
+ (instancetype)categoryWithDictionary:(NSDictionary *)dict;

/**
 转换为字典
 @return 字典数据
 */
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END 