# 工作台 API 文档

## 概述

工作台模块提供了应用管理、分类管理、横幅管理等功能的API接口。所有接口都需要用户认证。

**Base URL**: `/v1/workplace`

**认证方式**: Bearer Token (在请求头中添加 `Authorization: Bearer {token}`)

---

## 📱 应用管理

### 1. 获取用户添加的应用列表

获取当前用户已添加到工作台的应用列表

**接口地址**: `GET /v1/workplace/app`

**请求参数**: 无

**响应示例**:
```json
[
  {
    "app_id": "app_001",
    "sort_num": 3,
    "icon": "https://example.com/icon.png",
    "name": "应用名称",
    "description": "应用描述",
    "app_category": "机器人",
    "status": 1,
    "jump_type": 0,
    "app_route": "app://route",
    "web_route": "https://web.route",
    "is_paid_app": 0
  }
]
```

**响应字段说明**:
- `app_id`: 应用唯一ID
- `sort_num`: 排序号（数字越大越靠前）
- `icon`: 应用图标URL
- `name`: 应用名称
- `description`: 应用描述
- `app_category`: 应用分类
- `status`: 状态 (0=禁用, 1=启用)
- `jump_type`: 打开方式 (0=网页, 1=原生)
- `app_route`: 原生应用打开地址
- `web_route`: 网页打开地址
- `is_paid_app`: 是否为付费应用 (0=否, 1=是)

---

### 2. 添加应用到工作台

将指定应用添加到用户的工作台

**接口地址**: `POST /v1/workplace/apps/{app_id}`

**路径参数**:
- `app_id`: 应用ID

**请求参数**: 无

**响应示例**:
```json
{
  "status": 200,
  "msg": "success"
}
```

---

### 3. 从工作台移除应用

从用户工作台移除指定应用

**接口地址**: `DELETE /v1/workplace/apps/{app_id}`

**路径参数**:
- `app_id`: 应用ID

**请求参数**: 无

**响应示例**:
```json
{
  "status": 200,
  "msg": "success"
}
```

---

### 4. 应用排序

重新排序用户工作台的应用

**接口地址**: `PUT /v1/workplace/app/reorder`

**请求参数**:
```json
{
  "app_ids": ["app_001", "app_002", "app_003"]
}
```

**参数说明**:
- `app_ids`: 应用ID数组，按照期望的排序顺序排列

**响应示例**:
```json
{
  "status": 200,
  "msg": "success"
}
```

---

## 📊 常用应用

### 5. 获取常用应用列表

获取用户的常用应用列表（按使用次数排序）

**接口地址**: `GET /v1/workplace/app/record`

**请求参数**: 无

**响应示例**:
```json
[
  {
    "is_added": 1,
    "app_id": "app_001",
    "sort_num": 0,
    "icon": "https://example.com/icon.png",
    "name": "应用名称",
    "description": "应用描述",
    "app_category": "机器人",
    "status": 1,
    "jump_type": 0,
    "app_route": "app://route",
    "web_route": "https://web.route",
    "is_paid_app": 0
  }
]
```

**响应字段说明**:
- `is_added`: 是否已添加到工作台 (0=未添加, 1=已添加)
- 其他字段含义同应用列表接口

---

### 6. 添加应用使用记录

记录用户使用应用的行为，用于统计常用应用

**接口地址**: `POST /v1/workplace/apps/{app_id}/record`

**路径参数**:
- `app_id`: 应用ID

**请求参数**: 无

**响应示例**:
```json
{
  "status": 200,
  "msg": "success"
}
```

---

### 7. 删除应用使用记录

删除指定应用的使用记录

**接口地址**: `DELETE /v1/workplace/apps/{app_id}/record`

**路径参数**:
- `app_id`: 应用ID

**请求参数**: 无

> 注意：目前代码实现中使用查询参数 `?app_id=xxx` 来获取应用ID，建议在实际调用时传递查询参数

**响应示例**:
```json
{
  "status": 200,
  "msg": "success"
}
```

---

## 📂 分类管理

### 8. 获取应用分类列表

获取所有应用分类

**接口地址**: `GET /v1/workplace/category`

**请求参数**: 无

**响应示例**:
```json
[
  {
    "category_no": "cat_001",
    "name": "机器人",
    "sort_num": 3
  },
  {
    "category_no": "cat_002", 
    "name": "客服",
    "sort_num": 2
  }
]
```

**响应字段说明**:
- `category_no`: 分类编号
- `name`: 分类名称
- `sort_num`: 排序号（数字越大越靠前）

---

### 9. 获取分类下的应用

获取指定分类下的所有应用

**接口地址**: `GET /v1/workplace/categorys/{category_no}/app`

**路径参数**:
- `category_no`: 分类编号

**请求参数**: 无

**响应示例**:
```json
[
  {
    "is_added": 0,
    "app_id": "app_001",
    "sort_num": 1,
    "icon": "https://example.com/icon.png",
    "name": "应用名称",
    "description": "应用描述",
    "app_category": "机器人",
    "status": 1,
    "jump_type": 0,
    "app_route": "app://route",
    "web_route": "https://web.route",
    "is_paid_app": 0
  }
]
```

**响应字段说明**:
- `is_added`: 是否已添加到用户工作台 (0=未添加, 1=已添加)
- `sort_num`: 在分类中的排序号
- 其他字段含义同应用列表接口

---

## 🎨 横幅管理

### 10. 获取横幅列表

获取工作台横幅列表

**接口地址**: `GET /v1/workplace/banner`

**请求参数**: 无

**响应示例**:
```json
[
  {
    "banner_no": "banner_001",
    "cover": "https://example.com/banner.jpg",
    "title": "横幅标题",
    "description": "横幅描述",
    "jump_type": 0,
    "route": "https://example.com/target",
    "sort_num": 1,
    "created_at": "2024-01-01 12:00:00"
  }
]
```

**响应字段说明**:
- `banner_no`: 横幅编号
- `cover`: 横幅封面图片URL
- `title`: 横幅标题
- `description`: 横幅描述
- `jump_type`: 打开方式 (0=网页, 1=原生)
- `route`: 跳转地址
- `sort_num`: 排序号（数字越大越靠前）
- `created_at`: 创建时间

---

## ❌ 错误响应

当请求失败时，会返回以下格式的错误响应：

```json
{
  "status": 400,
  "msg": "错误信息描述"
}
```

**常见错误码**:
- `400`: 请求参数错误
- `401`: 未授权访问
- `403`: 权限不足
- `404`: 资源不存在
- `500`: 服务器内部错误

---

## 🔧 使用示例

### JavaScript 示例

```javascript
// 获取用户应用列表
const getMyApps = async () => {
  const response = await fetch('/v1/workplace/app', {
    method: 'GET',
    headers: {
      'Authorization': 'Bearer your_token_here',
      'Content-Type': 'application/json'
    }
  });
  const data = await response.json();
  return data;
};

// 添加应用
const addApp = async (appId) => {
  const response = await fetch(`/v1/workplace/apps/${appId}`, {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer your_token_here',
      'Content-Type': 'application/json'
    }
  });
  const data = await response.json();
  return data;
};

// 应用排序
const reorderApps = async (appIds) => {
  const response = await fetch('/v1/workplace/app/reorder', {
    method: 'PUT',
    headers: {
      'Authorization': 'Bearer your_token_here',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ app_ids: appIds })
  });
  const data = await response.json();
  return data;
};
```

### cURL 示例

```bash
# 获取应用列表
curl -X GET "https://api.botgate.cn/v1/workplace/app" \
  -H "Authorization: Bearer your_token_here" \
  -H "Content-Type: application/json"

# 添加应用
curl -X POST "https://api.botgate.cn/v1/workplace/apps/app_001" \
  -H "Authorization: Bearer your_token_here" \
  -H "Content-Type: application/json"

# 应用排序
curl -X PUT "https://api.botgate.cn/v1/workplace/app/reorder" \
  -H "Authorization: Bearer your_token_here" \
  -H "Content-Type: application/json" \
  -d '{"app_ids": ["app_001", "app_002", "app_003"]}'
```

---

## 📝 注意事项

1. **认证要求**: 所有接口都需要在请求头中携带有效的 Bearer Token
2. **排序机制**: 排序号数字越大越靠前显示
3. **应用状态**: 只有状态为1（启用）的应用才能被添加到工作台
4. **重复添加**: 重复添加同一个应用不会报错，会自动跳过
5. **使用记录**: 应用使用记录用于生成常用应用列表，按使用次数排序
6. **跳转类型**: jump_type=0 使用 web_route，jump_type=1 使用 app_route

---

## 📱 客户端集成建议

### 工作台首页展示流程
1. 调用 `GET /v1/workplace/banner` 获取横幅
2. 调用 `GET /v1/workplace/app` 获取用户应用列表
3. 调用 `GET /v1/workplace/app/record` 获取常用应用（可选）

### 应用商店页面流程
1. 调用 `GET /v1/workplace/category` 获取分类列表
2. 调用 `GET /v1/workplace/categorys/{category_no}/app` 获取分类下应用
3. 根据 `is_added` 字段显示"添加"或"已添加"状态

### 应用使用统计
- 用户点击应用时调用 `POST /v1/workplace/apps/{app_id}/record` 记录使用
- 定期调用常用应用接口更新常用应用列表 