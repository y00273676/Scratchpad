# Scratchpad

[English](#english) · [中文](#中文)

---

## English

A lightweight scratch pad — open and type, close and forget.

### Features

- Ready to type on launch (input auto-focused)
- Multi-line editing with native `NSTextView`
- Placeholder hint disappears when focused
- Double-click the top bar to maximize / restore
- No persistence — content is lost when closed
- No database, no account system
- Like an ultra-minimal Notepad

### Tech Stack

- Swift 6
- SwiftUI
- AppKit (`NSTextView` wrapper)

### Project Structure

```
Scratchpad/
├── Package.swift
├── Sources/Scratchpad/
│   ├── ScratchpadApp.swift        # App entry + window config
│   ├── ContentView.swift          # Main UI
│   ├── TextEditorView.swift       # NSTextView wrapper
│   └── WindowTitleBar.swift       # Title bar drag & maximize
├── Info.plist
├── Makefile                       # Build / package / install
└── gen-icon.py                    # Icon generator
```

### Build & Install

```bash
make          # Build release + create .app bundle
make install  # Install to /Applications (Launchpad / Spotlight)
make clean    # Remove build artifacts
```

Open the app:

```bash
open build/Scratchpad.app
```

### Design

| Item       | Value              |
|------------|--------------------|
| Background | `#1a1a1d`          |
| Text       | `#bfbfc7`          |
| Cursor     | `#8c8d99`          |
| Font       | System 14pt Regular |
| Line gap   | 6pt                |

### Requirements

- macOS 14+
- Minimal, clean, product-grade aesthetic
- Clear hierarchy, restrained motion, no visual clutter
- Avoid: heavy gradients, emoji, cheap glow, stacked large radii, overcrowded UI

---

## 中文

一个「临时记事本」—— 打开就能输入，关闭即丢失。

### 功能

- 打开后自动聚焦输入框，可直接输入
- 多行编辑，基于原生 `NSTextView`
- 占位提示「在这里随便记录东西...」在获得焦点后消失
- 双击窗口顶部上边框可最大化 / 还原
- 不做持久化，关闭后内容丢失
- 无需数据库、无需账号系统
- 类似一个超轻量版 Notepad

### 技术栈

- Swift 6
- SwiftUI
- AppKit（NSTextView 原生包装）

### 项目结构

```
Scratchpad/
├── Package.swift
├── Sources/Scratchpad/
│   ├── ScratchpadApp.swift        # App 入口 + 窗口配置
│   ├── ContentView.swift          # 主界面
│   ├── TextEditorView.swift       # NSTextView 包装器
│   └── WindowTitleBar.swift       # 标题栏拖动与最大化
├── Info.plist
├── Makefile                       # 编译 / 打包 / 安装
└── gen-icon.py                    # 图标生成脚本
```

### 构建与安装

```bash
make          # 编译 release + 生成 .app
make install  # 安装到 /Applications（Launchpad / Spotlight 可找到）
make clean    # 清理构建产物
```

打开应用：

```bash
open build/Scratchpad.app
```

### 设计

| 项目   | 值                  |
|--------|---------------------|
| 背景   | `#1a1a1d`           |
| 文字   | `#bfbfc7`           |
| 光标   | `#8c8d99`           |
| 字体   | 系统 14pt Regular   |
| 行间距 | 6pt                 |

### 要求

- macOS 14+
- 风格定位：极简、干净、有产品感
- 信息层级清晰，动效克制，无过度装饰
- 禁止：过度渐变、Emoji、廉价发光、大圆角堆叠、信息过满
