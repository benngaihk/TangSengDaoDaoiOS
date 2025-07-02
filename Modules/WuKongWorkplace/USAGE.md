# WuKongWorkplace 使用指南

## 概述

WuKongWorkplace 是悟空IM的工作台模块，提供了完整的应用管理、分类管理、横幅管理等功能。

## 快速开始

### 1. 导入模块

```objc
#import <WuKongWorkplace/WuKongWorkplace.h>
```

### 2. 基本使用

#### 获取工作台首页数据

```objc
[[WKWorkplaceManager shared] getWorkplaceHomeDataWithCompletion:^(NSArray<WKWorkplaceBanner *> *banners, NSArray<WKWorkplaceApp *> *apps, NSError *error) {
    if (error) {
        NSLog(@"获取工作台数据失败: %@", error.localizedDescription);
        return;
    }
    
    // 更新UI
    self.banners = banners;
    self.apps = apps;
    [self.tableView reloadData];
}];
```

#### 获取应用分类

```objc
[[WKWorkplaceManager shared] getAppStoreDataWithCompletion:^(NSArray<WKWorkplaceCategory *> *categories, NSError *error) {
    if (error) {
        NSLog(@"获取分类数据失败: %@", error.localizedDescription);
        return;
    }
    
    self.categories = categories;
    [self.collectionView reloadData];
}];
```

#### 点击应用

```objc
- (void)didSelectApp:(WKWorkplaceApp *)app {
    // 使用管理器打开应用（自动记录使用）
    [[WKWorkplaceManager shared] openApp:app fromViewController:self];
}
```

## 高级用法

### 直接使用API

```objc
// 获取用户应用列表
[[[WKWorkplaceAPI shared] getUserApps] then:^id(NSArray<WKWorkplaceApp *> *apps) {
    // 处理应用列表
    return nil;
}].catch(^(NSError *error) {
    // 处理错误
});

// 添加应用到工作台
[[[WKWorkplaceAPI shared] addApp:@"app_001"] then:^id(NSDictionary *result) {
    // 添加成功
    return nil;
}].catch(^(NSError *error) {
    // 添加失败
});

// 应用排序
NSArray *appIds = @[@"app_001", @"app_002", @"app_003"];
[[[WKWorkplaceAPI shared] reorderApps:appIds] then:^id(NSDictionary *result) {
    // 排序成功
    return nil;
}].catch(^(NSError *error) {
    // 排序失败
});
```

### 获取分类下的应用

```objc
[[[WKWorkplaceAPI shared] getAppsInCategory:@"cat_001"] then:^id(NSArray<WKWorkplaceApp *> *apps) {
    // 处理应用列表
    for (WKWorkplaceApp *app in apps) {
        NSLog(@"应用: %@, 是否已添加: %@", app.name, app.isAdded ? @"是" : @"否");
    }
    return nil;
}].catch(^(NSError *error) {
    // 处理错误
});
```

### 批量操作

```objc
// 批量添加应用
NSArray *appIds = @[@"app_001", @"app_002"];
[[WKWorkplaceManager shared] batchAddApps:appIds completion:^(BOOL success, NSError *error) {
    if (success) {
        NSLog(@"批量添加成功");
    } else {
        NSLog(@"批量添加失败: %@", error.localizedDescription);
    }
}];

// 批量移除应用
[[WKWorkplaceManager shared] batchRemoveApps:appIds completion:^(BOOL success, NSError *error) {
    if (success) {
        NSLog(@"批量移除成功");
    } else {
        NSLog(@"批量移除失败: %@", error.localizedDescription);
    }
}];
```

## 数据模型

### WKWorkplaceApp

```objc
@property (nonatomic, strong) NSString *appId;        // 应用ID
@property (nonatomic, strong) NSString *name;         // 应用名称
@property (nonatomic, strong) NSString *icon;         // 应用图标
@property (nonatomic, assign) NSInteger jumpType;     // 跳转类型 (0=网页, 1=原生)
@property (nonatomic, strong) NSString *webRoute;     // 网页地址
@property (nonatomic, strong) NSString *appRoute;     // 原生地址
@property (nonatomic, assign) NSInteger isAdded;      // 是否已添加
```

### WKWorkplaceCategory

```objc
@property (nonatomic, strong) NSString *categoryNo;   // 分类编号
@property (nonatomic, strong) NSString *name;         // 分类名称
@property (nonatomic, assign) NSInteger sortNum;      // 排序号
```

### WKWorkplaceBanner

```objc
@property (nonatomic, strong) NSString *bannerNo;     // 横幅编号
@property (nonatomic, strong) NSString *title;        // 标题
@property (nonatomic, strong) NSString *cover;        // 封面图片
@property (nonatomic, assign) NSInteger jumpType;     // 跳转类型
@property (nonatomic, strong) NSString *route;        // 跳转地址
```

## 通过模块方法调用

如果您想通过模块系统调用API，可以使用以下方法：

```objc
// 获取用户应用
id result = [[WKModuleManager shared] invokeMethod:@"workplace.getUserApps" param:nil];

// 添加应用
NSDictionary *param = @{@"app_id": @"app_001"};
id result = [[WKModuleManager shared] invokeMethod:@"workplace.addApp" param:param];

// 应用排序
NSDictionary *param = @{@"app_ids": @[@"app_001", @"app_002"]};
id result = [[WKModuleManager shared] invokeMethod:@"workplace.reorderApps" param:param];
```

## 注意事项

1. **认证要求**: 所有API都需要有效的Bearer Token
2. **错误处理**: 请务必处理网络请求可能出现的错误
3. **线程安全**: 所有回调都在主线程执行，可以直接更新UI
4. **性能优化**: 建议缓存应用列表和分类数据，避免频繁请求
5. **应用跳转**: 确保URL scheme已正确配置 