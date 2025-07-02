# WuKongWorkplace 集成示例

## 集成步骤

### 1. 添加Pod依赖

在项目的 `Podfile` 中添加：

```ruby
pod 'WuKongWorkplace', :path => './Modules/WuKongWorkplace'
```

### 2. 在主TabBar控制器中集成

在 `WKMainTabController.m` 中：

```objc
// 导入工作台模块
#import <WuKongWorkplace/WuKongWorkplace.h>

// 在viewDidLoad中添加工作台tab
[self setupChildVC:WKWorkplaceVC.class title:@"" andImage:@"WorkplaceTab" andSelectImage:@"WorkplaceTabSelected"];
```

### 3. 准备图标资源

需要准备以下图标资源并添加到主项目：
- `WorkplaceTab.png` - 工作台未选中图标
- `WorkplaceTabSelected.png` - 工作台选中图标

### 4. 配置网络基础设置

工作台模块依赖 WuKongBase 模块的网络配置，确保：
- API基础URL已正确配置
- 用户认证Token可以正确获取

### 5. 可选：自定义UI样式

可以通过 WKApp.shared.config 来自定义主题色、字体等样式。

## 功能说明

### 工作台首页 (WKWorkplaceVC)
- 显示横幅轮播
- 显示已添加的应用网格
- 提供进入应用商店的入口

### 应用商店 (WKWorkplaceAppStoreVC)  
- 按分类浏览应用
- 添加/移除应用
- 查看应用详情

### API接口使用

```objc
// 获取工作台数据
[[WKWorkplaceManager shared] getWorkplaceHomeDataWithCompletion:^(NSArray<WKWorkplaceBanner *> *banners, NSArray<WKWorkplaceApp *> *apps, NSError *error) {
    // 处理结果
}];

// 点击应用（自动记录使用并打开）
[[WKWorkplaceManager shared] openApp:app fromViewController:self];
```

## 注意事项

1. 确保网络请求权限和HTTPS配置正确
2. 图标资源尺寸建议：
   - @1x: 25x25
   - @2x: 50x50  
   - @3x: 75x75
3. 模块会自动注册到WuKong模块系统中
4. 支持深色模式自动适配 