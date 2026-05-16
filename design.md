# OmniTodo Design System

> 从 `focus_session_screen.dart` 提取的设计规范，用于指导整个应用的 UI 设计。

---

## 1. 色彩系统

### 主色

| Token | 色值 | 用途 |
|-------|------|------|
| `primary` | `#004AC6` | 按钮、进度条、选中态、图标高亮 |
| `primaryContainer` | `#2563EB` | 渐变按钮终点、次要强调 |
| `onPrimary` | `#FFFFFF` | 主色上的文字/图标 |

### 表面色（由浅到深）

| Token | 色值 | 用途 |
|-------|------|------|
| `surfaceContainerLowest` | `#FFFFFF` | **卡片背景**（纯白） |
| `surfaceContainerLow` | `#F8F8FA` | 次级容器背景 |
| `surface` | `#FAFAFC` | 内部小项背景（如统计子项） |
| `surfaceContainerHigh` | `#EFEFF2` | 暂停按钮背景、Slider 非活跃轨道 |
| `surfaceContainer` | `#F3F3F6` | **页面背景**、Toggle 关闭态、重置按钮 |
| `surfaceContainerHighest` | `#E8E8EC` | **卡片边框**、分隔线、未选中按钮边框 |

### 文字色

| Token | 色值 | 用途 |
|-------|------|------|
| `onSurface` | `#1A1C1D` | **所有正文和标题**（接近纯黑） |
| `onSurfaceVariant` | `#434655` | 仅用于弹窗副文本、图标等次要信息 |

### 规则

- **正文/标题一律用 `onSurface`**，不用 `onSurfaceVariant`
- 主色仅用于可交互元素（按钮、选中态、链接）
- 灰色仅用于 `surfaceContainerHighest`（边框）和 `surfaceContainerHigh`（次要背景）

---

## 2. 字体

### 字体家族

- **全局字体**: `GoogleFonts.nunito()` — 圆润无衬线体
- 通过 `GoogleFonts.nunito().fontFamily` 获取 fontFamily 名称

### 字体层级

| 层级 | Size | Weight | LetterSpacing | 用途 |
|------|------|--------|---------------|------|
| Display | 96px / 72px | w800 | 1 | 计时器数字（桌面/移动） |
| Headline | 56px | w800 | 1 | 页面大标题（如 "Stay present."） |
| Title | 16px | w800 | 0 | 卡片标题（Daily Overview, Queue, Configuration） |
| Body Large | 18px | bold | 0 | 按钮文字（Start Session, Pause） |
| Body | 14px | w800 | 0 | 正文内容（任务标题、状态标签） |
| Body Small | 13px | w800 | 0 | 模式按钮、Toggle 标签 |
| Label | 12px | w600 | 0 | 链接文字（View All）、徽章文字 |
| Caption | 11px | w800 | 1.2 | 大写标签（FOCUS TIME, TIMER MODE） |
| Caption Sm | 12px | w800 | 0 | 预设按钮数字（25, 45, 60） |

### 规则

- **所有文字用 w800**（ExtraBold），确保清晰可读
- 仅链接文字（View All）和徽章用 w600
- 大写标签统一加 `letterSpacing: 1.2`
- 计时器用 `tabular-nums` 等宽数字（通过字体特性实现）

---

## 3. 圆角

| Token | 值 | 用途 |
|-------|-----|------|
| `16px` | `BorderRadius.circular(16)` | **所有卡片、按钮、输入框** |
| `12px` | `BorderRadius.circular(12)` | 预设按钮（小尺寸） |
| `full` | `9999px` | 胶囊按钮（Start Session）、徽章标签 |
| `circle` | `BoxShape.circle` | 计时器圆环、重置按钮、Toggle 圆点 |

### 规则

- 主要容器统一 `16px` 圆角
- 小型交互元素用 `12px`
- 胶囊形元素用 `full`

---

## 4. 间距系统

### 页面级

| 场景 | 值 |
|------|-----|
| 桌面端水平内边距 | 48px |
| 桌面端垂直内边距 | 48px |
| 移动端水平内边距 | 24px |
| 移动端垂直内边距 | 32px |
| 栏间距（桌面 Row） | 48px |
| 最大内容宽度 | 1200px |

### 组件级

| 场景 | 值 |
|------|-----|
| 卡片内边距 | 24px |
| 统计子项内边距 | 16px |
| 队列项内边距 | 16px |
| 卡片标题区下方 | 16px |
| 卡片之间 | 32px |
| 同组元素之间 | 12px / 8px |
| 按钮内边距 | horizontal: 32-40px, vertical: 20px |

---

## 5. 阴影

### 卡片阴影

```dart
BoxShadow(
  color: Color(0xFF1E293B).withValues(alpha: 0.04),
  blurRadius: 24,
  offset: Offset(0, 8),
)
```

### 主按钮阴影

```dart
BoxShadow(
  color: AppColors.primary.withValues(alpha: 0.3),
  blurRadius: 16,
  offset: Offset(0, 8),
)
```

### 计时器呼吸光晕

```dart
BoxShadow(
  color: AppColors.primary.withValues(alpha: 0.04~0.20),  // 动态
  blurRadius: 60,
  spreadRadius: 10,
)
```

### 规则

- 阴影极淡（alpha 0.04），靠层次感而非阴影
- 主按钮用较高 alpha（0.3）强调立体感
- 计时器用呼吸动画动态调整光晕透明度

---

## 6. 组件规范

### 卡片（Card）

```dart
Container(
  padding: EdgeInsets.all(24),
  decoration: BoxDecoration(
    color: AppColors.surfaceContainerLowest,  // 纯白
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.surfaceContainerHighest),  // 极浅灰边框
  ),
)
```

### 主要操作按钮（Primary Action）

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.primary, AppColors.primaryContainer],
    ),
    borderRadius: BorderRadius.circular(AppBorderRadius.full),  // 胶囊形
    boxShadow: [...],  // primary alpha 0.3
  ),
)
```

### 次要操作按钮（Secondary Action）

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
  decoration: BoxDecoration(
    color: AppColors.surfaceContainerHigh,
    borderRadius: BorderRadius.circular(AppBorderRadius.full),
  ),
)
```

### 圆形图标按钮

```dart
Container(
  width: 56, height: 56,
  decoration: BoxDecoration(
    color: AppColors.surfaceContainer,
    shape: BoxShape.circle,
  ),
)
```

### 选项按钮（选中/未选中）

```dart
// 选中
color: AppColors.primary, borderRadius: 16, 无边框
// 未选中
color: AppColors.surface, borderRadius: 16, border: surfaceContainerHighest
```

### Toggle 开关

```dart
AnimatedContainer(
  width: 44, height: 24,
  borderRadius: 12,
  color: value ? AppColors.primary : AppColors.surfaceContainer,
  child: AnimatedAlign(
    alignment: value ? centerRight : centerLeft,
    child: Circle(width: 20, height: 20, color: white),
  ),
)
```

### 徽章标签（Badge）

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  decoration: BoxDecoration(
    color: AppColors.primary.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(AppBorderRadius.full),
  ),
)
```

---

## 7. 分隔线

```dart
BorderSide(color: AppColors.surfaceContainerHighest, width: 0.5)
```

- 极细（0.5px）、极浅灰
- 用于面板内部区域分隔，不用于卡片之间

---

## 8. 动画

| 动画 | 时长 | 曲线 | 用途 |
|------|------|------|------|
| 呼吸脉冲 | 2000ms | easeInOut | 计时器活跃时光晕脉冲 |
| 脉冲圆点 | 1500ms | easeOut | 状态徽章圆点 ping 动画 |
| 重置旋转 | 500ms | linear | 重置按钮旋转 180 度 |
| 按钮切换 | 300ms | - | 控制按钮 AnimatedSwitcher |
| Toggle | 200ms | - | 开关滑动和颜色过渡 |

---

## 9. 布局模式

### 桌面端（>=768px）

```
┌─────────┬──────────────────────┬─────────┐
│ Left    │      Center          │  Right  │
│ flex: 3 │      flex: 6         │ flex: 3 │
│ Stats   │  Label + Title       │ Config  │
│ Queue   │  Timer Circle        │         │
│         │  Controls            │         │
└─────────┴──────────────────────┴─────────┘
```

### 移动端（<768px）

```
┌──────────────────────────┐
│ Center (Timer)           │
│ Stats                    │
│ Queue                    │
│ Config                   │
└──────────────────────────┘
```

---

## 10. 设计原则总结

1. **白卡灰底** — 页面灰色底 (`surfaceContainer`)，卡片纯白 (`surfaceContainerLowest`)，用极浅灰边框 (`surfaceContainerHighest`) 定义轮廓
2. **圆润风格** — Nunito 字体 + 16px 圆角 + 胶囊按钮
3. **深色文字** — 所有正文用 `onSurface` (#1A1C1D)，确保高对比度
4. **极简边框** — 边框仅用 `surfaceContainerHighest` (#E8E8EC)，不使用深灰
5. **主色克制** — 蓝色仅用于可交互元素，不滥用
6. **留白充足** — 卡片内 24px，卡片间 32px，页面边距 48px
