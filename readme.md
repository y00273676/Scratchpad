# Scratchpad

一个「临时记事本」—— 打开就能输入，关闭即丢失。

## 功能

- 打开就能输入
- 支持多行编辑
- 不需要持久化（关闭即丢失）
- 不需要数据库
- 不需要账号系统
- 类似一个超轻量版 Notepad

## 技术栈

- Swift 6
- SwiftUI
- AppKit（NSTextView 原生包装）

## 项目结构

```
Scratchpad/
├── Package.swift                  # SPM 包配置
├── Sources/Scratchpad/
│   ├── ScratchpadApp.swift        # App 入口 + 窗口配置
│   ├── ContentView.swift          # 主界面
│   └── TextEditorView.swift       # NSTextView 包装器
├── Info.plist                     # App bundle 元数据
├── Makefile                       # 编译 / 打包 / 安装
└── gen-icon.py                    # 图标生成脚本
```

## 构建与安装

```bash
make          # 编译 release + 生成 .app
make install  # 安装到 ~/Applications（Launchpad / Spotlight 可找到）
make clean    # 清理构建产物
```

## 设计

| 项目 | 值 |
|------|-----|
| 背景 | `#1a1a1d` |
| 文字 | `#bfbfc7` |
| 光标 | `#8c8d99` |
| 字体 | 系统 14pt Regular |
| 行间距 | 6pt |

## 要求

- 风格定位：极简、科技、高级、产品感强
- 信息层级清晰，视觉干净
- 动效克制，无过度装饰
- 禁止：过度渐变、Emoji、廉价发光、大圆角堆叠、信息过满
