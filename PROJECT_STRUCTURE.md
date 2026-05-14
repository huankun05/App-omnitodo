# OmniTodo 项目说明文档

## 项目概述

OmniTodo 是一款跨平台任务管理应用，采用 Flutter + NestJS 技术栈开发，支持 iOS、Android、Web、Windows、Linux、macOS 等主流平台。

### 技术架构

- **前端框架**: Flutter 3.41.6
- **状态管理**: Riverpod 2.x
- **路由管理**: GoRouter
- **本地数据库**: SQLite (sqflite)
- **后端框架**: NestJS
- **数据模型**: Freezed (不可变数据类)

---

## 目录结构

```
App-omnitodo/
├── lib/                          # Flutter 应用核心代码
│   ├── main.dart                 # 应用入口
│   ├── core/                     # 核心模块
│   │   ├── constants/            # 常量定义
│   │   ├── database/             # 数据库助手
│   │   ├── l10n/                 # 国际化
│   │   ├── network/              # 网络请求相关
│   │   ├── providers/            # Riverpod providers
│   │   ├── app_bootstrap.dart    # 应用初始化
│   │   ├── exceptions.dart       # 异常定义
│   │   └── router.dart          # 路由配置
│   ├── data/                     # 数据层
│   │   ├── models/               # 数据模型 (Freezed)
│   │   ├── providers/            # 数据 providers
│   │   └── services/             # 业务服务
│   └── ui/                       # 界面层
│       ├── screens/              # 页面组件
│       └── widgets/              # 通用组件
├── server/                        # NestJS 后端服务
│   └── src/
│       ├── auth/                 # 认证模块
│       ├── tasks/                # 任务模块
│       ├── projects/             # 项目模块
│       ├── subtasks/             # 子任务模块
│       ├── users/                # 用户模块
│       └── telemetry/            # 遥测数据
├── UI/                           # UI 设计参考
├── android/                      # Android 平台代码
├── ios/                          # iOS 平台代码
├── web/                          # Web 平台代码
├── windows/                      # Windows 平台代码
├── linux/                        # Linux 平台代码
└── macos/                        # macOS 平台代码
```

---

## 核心模块

### Flutter 应用 (lib/)

#### core/ - 核心模块

| 文件 | 说明 |
|------|------|
| `router.dart` | GoRouter 路由配置，定义应用导航结构 |
| `app_bootstrap.dart` | 应用启动初始化逻辑 |
| `exceptions.dart` | 自定义异常类型定义 |

**providers/**
- `theme_provider.dart` - 主题状态管理
- `settings_provider.dart` - 应用设置管理

**network/**
- `network_manager.dart` - Dio 网络请求管理器
- `auth_interceptor.dart` - 认证拦截器

**database/**
- `database_helper.dart` - SQLite 数据库初始化与操作

#### data/ - 数据层

**models/** - 使用 Freezed 生成的数据模型
- `task_models.dart` - 任务相关模型
- `auth_models.dart` - 认证相关模型
- `project_models.dart` - 项目相关模型
- `config_models.dart` - 配置相关模型

**providers/** - Riverpod 状态提供者
- `task_provider.dart` - 任务状态管理
- `project_provider.dart` - 项目状态管理

**services/** - 业务服务层
- `auth_service.dart` - 认证服务
- `task_service.dart` - 任务服务
- `project_service.dart` - 项目服务
- `config_service.dart` - 配置服务
- `telemetry_manager.dart` - 遥测数据管理

#### ui/ - 界面层

**screens/** - 页面组件
| 页面 | 说明 |
|------|------|
| `home_screen.dart` | 首页/仪表盘 |
| `calendar_screen.dart` | 日历视图 |
| `my_tasks_screen.dart` | 我的任务列表 |
| `create_task_screen.dart` | 创建任务 |
| `task_details_screen.dart` | 任务详情 |
| `focus_session_screen.dart` | 专注模式 |
| `settings_screen.dart` | 设置页面 |
| `login_screen.dart` | 登录页 |
| `register_screen.dart` | 注册页 |

**widgets/** - 通用组件
- `app_widgets.dart` - 应用级通用组件
- `responsive_navigation.dart` - 响应式导航组件
- `project_nav_sidebar.dart` - 项目导航侧边栏

---

### NestJS 后端 (server/)

后端采用 NestJS 框架构建 RESTful API。

#### 模块结构

| 模块 | 路径 | 说明 |
|------|------|------|
| 认证模块 | `src/auth/` | 用户注册、登录、JWT 认证 |
| 任务模块 | `src/tasks/` | CRUD 任务操作 |
| 项目模块 | `src/projects/` | 项目管理 |
| 子任务模块 | `src/subtasks/` | 子任务管理 |
| 用户模块 | `src/users/` | 用户信息管理 |
| 遥测模块 | `src/telemetry/` | 数据分析遥测 |

#### 技术栈

- **ORM**: Prisma
- **数据库**: SQLite (开发环境)
- **认证**: JWT + Passport
- **API**: RESTful API

#### 数据库 Schema (Prisma)

位于 `server/prisma/schema.prisma`

---

## 依赖配置

### Flutter 核心依赖

```yaml
dependencies:
  flutter_riverpod: ^2.4.9    # 状态管理
  go_router: ^13.2.0         # 路由管理
  dio: ^5.4.0                 # HTTP 客户端
  freezed_annotation: ^2.4.1  # 不可变数据类
  json_annotation: ^4.8.1     # JSON 序列化
  sqflite: ^2.3.3+1           # SQLite 数据库
  go_router: ^13.2.0           # 路由
  intl: ^0.20.2               # 国际化

dev_dependencies:
  freezed: ^2.4.6             # 代码生成
  json_serializable: ^6.7.1   # JSON 代码生成
  riverpod_generator: ^2.3.9  # Riverpod 代码生成
  build_runner: ^2.4.8        # 代码生成运行器
```

---

## 运行项目

### Flutter 应用

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run

# Web 平台
flutter run -d chrome

# 代码生成 (model / provider)
dart run build_runner build --delete-conflicting-outputs
```

### NestJS 后端

```bash
cd server

# 安装依赖
npm install

# 启动开发服务器
npm run start:dev

# 构建生产版本
npm run build
```

---

## 环境变量

Flutter 应用需要 `.env` 文件：

```env
API_BASE_URL=http://localhost:3000
```

后端环境变量模板位于 `server/.env.supabase.template`

---

## UI 设计参考

设计参考位于 `UI/` 目录下，包含各页面的设计稿和实现代码片段：

- `calendar_view/` - 日历视图
- `create_task/` - 创建任务
- `empty_state/` - 空状态设计
- `focus_session/` - 专注模式
- `login/` - 登录页
- `my_tasks/` - 我的任务
- `settings/` - 设置页
- `statistics_insights/` - 统计洞察
- `task_details/` - 任务详情
- `omni_minimalist/` - 极简设计规范

---

## 平台特性

| 平台 | 状态 | 说明 |
|------|------|------|
| Android | ✅ | 完整支持 |
| iOS | ✅ | 完整支持 |
| Web | ✅ | SQLite 使用 sqflite_common_ffi_web |
| Windows | ✅ | 完整支持 |
| macOS | ✅ | 完整支持 |
| Linux | ✅ | 完整支持 |

---

## 版本信息

- **应用版本**: 1.0.0+1
- **Flutter SDK**: ^3.11.4
- **Dart SDK**: ^3.11.4

---

## 许可协议

私有项目，保留所有权利。
