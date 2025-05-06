
# PwdPass - macOS 密码管理器

PwdPass 是一个轻量级的 macOS 密码管理工具，它以菜单栏应用的形式运行，让您可以方便快捷地管理和访问您的密码。

## 功能特点

- 🔒 安全存储密码
- 📱 简洁的用户界面
- 🔍 快速搜索功能
- 🖥️ macOS 菜单栏快速访问
- 📋 一键复制密码
- 🎨 现代化的设计风格
- 🔐 密码可见性控制

## 应用截图

![Snipaste_2025-05-06_14-55-11](https://github.com/user-attachments/assets/8cfd5b13-c039-4c29-b4bb-c51dc53c16c6)
![Snipaste_2025-05-06_14-55-36](https://github.com/user-attachments/assets/d06e6cc2-d8cf-4df8-ba61-cecc4ae0efae)
![Snipaste_2025-05-06_14-56-04](https://github.com/user-attachments/assets/35a93f51-b78f-42a7-bfa2-e53e9f77d1f7)
![Snipaste_2025-05-06_15-03-36](https://github.com/user-attachments/assets/b2ebe81b-75da-41dc-ad5e-bc65207c4819)

## 系统要求

- macOS 11.0 或更高版本
- Xcode 13.0 或更高版本（用于构建）

## 安装说明

### 从源码构建

1. 克隆仓库：
```bash
git clone https://github.com/yourusername/pwdpass.git
```

2. 使用 Xcode 打开项目：
```bash
cd pwdpass
open pwdpass.xcodeproj
```

3. 在 Xcode 中选择目标设备并点击运行按钮，或使用快捷键 `Cmd + R` 构建和运行项目。

## 使用说明

1. 启动应用后，它会以图标的形式显示在 macOS 的菜单栏中
2. 点击菜单栏图标可以打开主界面
3. 使用 "+" 按钮添加新的密码条目
4. 在搜索框中输入关键词可以快速查找密码
5. 点击密码卡片上的复制按钮可以快速复制密码
6. 右键点击密码卡片可以进行更多操作

## 开发技术

- SwiftUI
- AppKit
- Combine

## 隐私说明

PwdPass 将所有密码安全地存储在本地，不会将任何数据上传到云端或发送到其他地方。

## 贡献

欢迎提交 Issue 和 Pull Request！
