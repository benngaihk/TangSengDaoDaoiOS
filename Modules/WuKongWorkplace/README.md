# WuKongWorkplace

[![Version](https://img.shields.io/cocoapods/v/WuKongWorkplace.svg?style=flat)](https://cocoapods.org/pods/WuKongWorkplace)
[![License](https://img.shields.io/cocoapods/l/WuKongWorkplace.svg?style=flat)](https://cocoapods.org/pods/WuKongWorkplace)
[![Platform](https://img.shields.io/cocoapods/p/WuKongWorkplace.svg?style=flat)](https://cocoapods.org/pods/WuKongWorkplace)

## 简介

WuKongWorkplace 是悟空IM的工作台模块，提供完整的应用管理、分类管理、横幅管理等功能。

## 功能特性

- 📱 **应用管理**: 添加、删除、排序工作台应用
- 📊 **常用应用**: 智能统计和展示常用应用
- 📂 **分类管理**: 按分类浏览和管理应用
- 🎨 **横幅管理**: 工作台横幅展示和跳转
- 🔐 **安全认证**: 所有接口支持Bearer Token认证

## 安装

WuKongWorkplace 通过 [CocoaPods](https://cocoapods.org) 进行安装。在您的 Podfile 中添加以下内容：

```ruby
pod 'WuKongWorkplace'
```

## 使用方法

### 基本配置

```objc
#import <WuKongWorkplace/WuKongWorkplace.h>

// 模块会自动初始化，无需手动配置
```

### 主要API

#### 应用管理
- 获取用户应用列表
- 添加/删除应用
- 应用排序

#### 常用应用
- 获取常用应用
- 记录应用使用
- 删除使用记录

#### 分类管理  
- 获取应用分类
- 获取分类下应用

#### 横幅管理
- 获取横幅列表

## 依赖

- WuKongBase
- PromiseKit
- Masonry
- SDWebImage
- AFNetworking

## 作者

tangtaoit, tt@wukong.ai

## 许可证

WuKongWorkplace 使用 MIT 许可证。详情请参阅 LICENSE 文件。 