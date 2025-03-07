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
            EmptyView()
        }
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
