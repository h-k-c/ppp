import SwiftUI
import AppKit

class StatusBarManager {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var menu: NSMenu
    private let mainWindowManager = MainWindowManager()
    
    init() {
        // 创建状态栏项
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // 创建弹出窗口
        popover = NSPopover()
        popover.contentSize = NSSize(width: 420, height: 480)
        popover.behavior = .transient
        popover.animates = true
        
        // 设置内容视图
        let contentView = ContentView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        // 创建右键菜单
        menu = NSMenu()
        let openItem = NSMenuItem(
            title: "打开主界面",
            action: #selector(openMainWindow),
            keyEquivalent: "o"
        )
        openItem.target = self
        menu.addItem(openItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(
            title: "退出",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        // 设置状态栏图标
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "key.fill", accessibilityDescription: "密码管理器")
            button.imagePosition = .imageLeft
            
            // 设置鼠标事件处理
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.action = #selector(handleClick)
            button.target = self
        }
        
        // 添加监听器，点击外部时关闭弹窗
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let self = self, self.popover.isShown {
                self.popover.performClose(event)
            }
        }
    }
    
    @objc private func handleClick(sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        
        switch event.type {
        case .rightMouseUp:
            // 右键显示菜单
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: sender.bounds.height + 8), in: sender)
        case .leftMouseUp:
            // 左键显示/隐藏面板
            togglePopover(sender)
        default:
            break
        }
    }
    
    @objc private func openMainWindow() {
        if popover.isShown {
            popover.performClose(nil)
        }
        mainWindowManager.showMainWindow()
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
    
    @objc private func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
} 