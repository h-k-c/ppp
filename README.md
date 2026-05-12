# PwdPass · macOS 密码管理器

> 住在菜单栏里的轻量密码管家，安全、快捷、纯本地。

---

## 简介

PwdPass 是一款 macOS 原生密码管理应用，以菜单栏图标的形式常驻系统，让你随时一键访问密码库。所有数据经加密后仅存储在本地，绝不上传云端，彻底保护个人隐私。

## 应用截图

![主界面](https://github.com/user-attachments/assets/8cfd5b13-c039-4c29-b4bb-c51dc53c16c6)
![搜索功能](https://github.com/user-attachments/assets/d06e6cc2-d8cf-4df8-ba61-cecc4ae0efae)
![添加密码](https://github.com/user-attachments/assets/35a93f51-b78f-42a7-bfa2-e53e9f77d1f7)
![密码卡片](https://github.com/user-attachments/assets/b2ebe81b-75da-41dc-ad5e-bc65207c4819)

## 功能特性

- 🔒 **加密本地存储** — 采用系统级加密（CryptoKit）保存密码条目，数据不离设备
- 🖥️ **菜单栏常驻** — 以系统状态栏图标运行，点击即弹出密码面板，不打扰正常使用
- 🔍 **快速搜索** — 输入关键词即时过滤密码列表，秒速定位目标条目
- 📋 **一键复制** — 点击复制按钮，密码即刻进入剪贴板，无需手动选择
- 👁️ **密码可见性切换** — 支持显示 / 隐藏密码，兼顾安全与便捷
- 🎨 **现代化 UI** — 基于 SwiftUI 打造，风格简洁，与 macOS 原生设计语言一致

## 技术栈

| 层次 | 技术 |
|------|------|
| UI 框架 | SwiftUI + AppKit |
| 响应式 | Combine |
| 加密 | CryptoKit（系统级） |
| 数据持久化 | 本地加密文件存储 |
| 架构模式 | MVVM |
| 最低系统 | macOS 11.0 (Big Sur)+ |

## 项目结构

```
pwdpass/
├── pwdpassApp.swift              # 应用入口，注册菜单栏图标
├── StatusBarManager.swift        # 系统状态栏图标与弹出窗口管理
├── MainWindowManager.swift       # 主窗口生命周期管理
├── ContentView.swift             # 密码列表主视图
├── Models/
│   └── PasswordItem.swift        # 密码条目数据模型
├── ViewModels/
│   └── PasswordViewModel.swift   # 密码列表状态管理（增删改查）
├── Views/
│   ├── PasswordCard.swift        # 密码卡片组件（显示 / 复制 / 删除）
│   └── AddPasswordSheet.swift    # 新增密码表单
├── Theme/
│   └── AppTheme.swift            # 主题颜色配置
└── Utils/
    ├── CryptoManager.swift       # 加解密工具
    └── StorageManager.swift      # 本地文件读写管理
```

## 构建与运行

### 前置要求

- macOS 12.0+（开发环境）
- Xcode 13.0+
- 运行环境：macOS 11.0+

### 步骤

```bash
git clone https://github.com/yourusername/pwdpass.git
cd ppp
open pwdpass.xcodeproj
```

在 Xcode 中选择 **My Mac** 作为运行目标，按 `Cmd + R` 构建运行。

启动后应用将以图标形式出现在 macOS 菜单栏右侧，点击即可打开密码管理面板。

## 使用说明

1. 启动后在菜单栏点击 PwdPass 图标打开面板
2. 点击 **"+"** 按钮添加新的密码条目
3. 在搜索框中输入关键词快速查找
4. 点击密码卡片上的复制按钮一键复制密码
5. 右键点击卡片可进行编辑或删除操作

## 隐私说明

PwdPass 将所有密码安全地存储在本地，不发起任何网络请求，不收集任何用户数据。

---

## English

# PwdPass · macOS Password Manager

> A lightweight password vault that lives in your menu bar — secure, instant, and entirely local.

### Overview

PwdPass is a native macOS password manager that runs as a menu bar application. It gives you one-click access to your credentials from anywhere on your desktop. All data is encrypted and stored locally — nothing ever leaves your machine.

### Features

- 🔒 **Encrypted Local Storage** — Passwords are secured with system-level CryptoKit encryption and never leave the device
- 🖥️ **Menu Bar Resident** — Runs as a status bar icon; click to reveal the password panel instantly
- 🔍 **Quick Search** — Type to filter your vault in real time
- 📋 **One-Click Copy** — Copy any password to the clipboard with a single tap
- 👁️ **Visibility Toggle** — Show or hide passwords on demand
- 🎨 **Modern UI** — SwiftUI-based design that feels native on macOS

### Tech Stack

| Layer | Technology |
|-------|-----------|
| UI Framework | SwiftUI + AppKit |
| Reactive | Combine |
| Encryption | CryptoKit (system-level) |
| Persistence | Encrypted local file storage |
| Architecture | MVVM |
| Minimum OS | macOS 11.0 (Big Sur)+ |

### Build & Run

**Requirements:** macOS 12.0+ (dev), Xcode 13.0+

```bash
git clone https://github.com/yourusername/pwdpass.git
cd ppp
open pwdpass.xcodeproj
```

Select **My Mac** as the run target in Xcode and press `Cmd + R`.

Once launched, the PwdPass icon appears in the macOS menu bar. Click it to open the password panel.

### How to Use

1. Click the PwdPass icon in the menu bar to open the panel
2. Press **"+"** to add a new password entry
3. Use the search box to filter entries in real time
4. Click the copy button on any card to copy the password
5. Right-click a card to edit or delete it

### Privacy

PwdPass stores all data locally in an encrypted format. No network requests are made. No analytics are collected.

### Contributing

Issues and Pull Requests are welcome!

### License

MIT
