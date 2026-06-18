# Scratchpad

[中文](#scratchpad) · [English](#english)

macOS 上的轻量临时记事本：打开即可输入，关闭后内容不保留。

## 功能

- 启动后自动聚焦，可直接输入
- 多行文本编辑（基于原生 `NSTextView`）
- 空内容时显示占位提示，获得焦点后隐藏
- 双击窗口顶部区域可最大化 / 还原
- 无持久化、无数据库、无账号体系

## 系统要求

| 项目 | 要求 |
| --- | --- |
| 运行环境 | macOS 14+ |
| 构建环境 | Swift 6、Xcode Command Line Tools |

## 快速开始

### 构建

```bash
make
```

生成 `build/Scratchpad.app`。

### 安装

```bash
make install
```

安装到 `/Applications`，可通过 Launchpad 或 Spotlight 启动。

### 本地运行

```bash
open build/Scratchpad.app
```

### 其他命令

| 命令 | 说明 |
| --- | --- |
| `make` | 编译 Release 并打包 `.app` |
| `make install` | 安装到 `/Applications` |
| `make clean` | 清理 `build/` 与 SwiftPM 构建产物 |

## 项目结构

```
Scratchpad/
├── Package.swift
├── Sources/Scratchpad/
│   ├── ScratchpadApp.swift    # 应用入口与窗口配置
│   ├── ContentView.swift      # 主界面
│   ├── TextEditorView.swift   # NSTextView 封装
│   └── WindowTitleBar.swift   # 标题栏拖动与最大化
├── Info.plist
├── Makefile                   # 构建、打包、安装
└── gen-icon.py                # 应用图标生成
```

## 技术栈

- Swift 6
- SwiftUI
- AppKit（`NSTextView` 封装）

## 设计规范

| 元素 | 值 |
| --- | --- |
| 背景色 | `#1a1a1d` |
| 文字色 | `#bfbfc7` |
| 光标色 | `#8c8d99` |
| 字体 | 系统 14pt Regular |
| 行间距 | 6pt |

视觉方向：极简、干净、层级清晰；动效克制，避免过度装饰。

---

## English

A lightweight scratch pad for macOS — open and type, content is not saved on close.

### Features

- Auto-focus on launch, ready to type immediately
- Multi-line editing via native `NSTextView`
- Placeholder hint when empty, hidden once focused
- Double-click the top bar to maximize / restore
- No persistence, database, or account system

### Requirements

| Item | Requirement |
| --- | --- |
| Runtime | macOS 14+ |
| Build | Swift 6, Xcode Command Line Tools |

### Quick Start

Build:

```bash
make
```

Output: `build/Scratchpad.app`.

Install to `/Applications`:

```bash
make install
```

Run locally:

```bash
open build/Scratchpad.app
```

| Command | Description |
| --- | --- |
| `make` | Build Release and bundle `.app` |
| `make install` | Install to `/Applications` |
| `make clean` | Remove `build/` and SwiftPM artifacts |

### Tech Stack

- Swift 6
- SwiftUI
- AppKit (`NSTextView` wrapper)

### Design

| Token | Value |
| --- | --- |
| Background | `#1a1a1d` |
| Text | `#bfbfc7` |
| Cursor | `#8c8d99` |
| Font | System 14pt Regular |
| Line spacing | 6pt |

Visual direction: minimal, clean, clear hierarchy; restrained motion, no visual clutter.
