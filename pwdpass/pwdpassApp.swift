//
//  pwdpassApp.swift
//  pwdpass
//
//  Created by 胡开成 on 2025/3/7.
//

import SwiftUI
import AppKit

@main
struct pwdpassApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            AboutView()
        }
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(width: 64, height: 64)
            Text("嗅密")
                .font(.headline)
            Text("版本 1.0")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("一款简洁的菜单栏密码管理器")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .frame(width: 220)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarManager: StatusBarManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 隐藏 dock 图标
        NSApp.setActivationPolicy(.accessory)

        // 初始化状态栏
        statusBarManager = StatusBarManager()
    }
}
