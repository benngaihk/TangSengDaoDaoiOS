//
//  WKWorkplaceBanner.h
//  WuKongWorkplace
//
//  Created by tt on 2024/01/01.
//

#import <Foundation/Foundation.h>
#import <WuKongBase/WuKongBase.h>

NS_ASSUME_NONNULL_BEGIN

/**
 工作台横幅模型
 */
@interface WKWorkplaceBanner : WKModel

/// 横幅编号
@property (nonatomic, copy) NSString *bannerNo;

/// 横幅封面图片URL
@property (nonatomic, copy) NSString *cover;

/// 横幅标题
@property (nonatomic, copy) NSString *title;

/// 横幅描述
@property (nonatomic, copy) NSString *bannerDescription;

/// 打开方式 (0=网页, 1=原生)
@property (nonatomic, assign) NSInteger jumpType;

/// 跳转地址
@property (nonatomic, copy) NSString *route;

/// 排序号（数字越大越靠前）
@property (nonatomic, assign) NSInteger sortNum;

/// 创建时间
@property (nonatomic, copy) NSString *createdAt;

/**
 从字典创建横幅对象
 @param dict 字典数据
 @return 横幅对象
 */
+ (instancetype)bannerWithDictionary:(NSDictionary *)dict;

/**
 转换为字典
 @return 字典数据
 */
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END 