import SwiftUI
import AppKit

class StatusBarManager {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    
    init() {
        // 创建状态栏项
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // 设置状态栏图标
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "key.fill", accessibilityDescription: "密码管理器")
            button.imagePosition = .imageLeft
        }
        
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
        
        // 添加点击事件
        if let button = statusItem.button {
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
        
        // 添加监听器，点击外部时关闭弹窗
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let self = self, self.popover.isShown {
                self.popover.performClose(event)
            }
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
} 