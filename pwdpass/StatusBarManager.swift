import SwiftUI
import AppKit

class StatusBarManager {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var menu: NSMenu

    init() {
        // 创建状态栏项
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        // 创建弹出窗口
        popover = NSPopover()
        popover.contentSize = NSSize(
            width: AppTheme.Layout.popoverWidth,
            height: AppTheme.Layout.popoverHeight
        )
        popover.behavior = .transient
        popover.animates = true

        // 设置内容视图
        let contentView = ContentView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, AppTheme.Spacing.windowH)
            .padding(.vertical, AppTheme.Spacing.windowV)
        popover.contentViewController = NSHostingController(rootView: contentView)

        // 创建右键菜单
        menu = NSMenu()
        let quitItem = NSMenuItem(
            title: "退出 嗅密",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        // 设置状态栏图标
        if let button = statusItem.button {
            if let image = NSImage(named: "StatusBarIcon") {
                image.size = NSSize(width: 16, height: 16)
                image.isTemplate = true
                button.image = image
            } else {
                button.image = NSImage(
                    systemSymbolName: "key.fill",
                    accessibilityDescription: "嗅密"
                )
            }

            button.imagePosition = .imageLeft
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.action = #selector(handleClick)
            button.target = self

            button.toolTip = "嗅密"
        }
    }

    @objc private func handleClick(sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        switch event.type {
        case .rightMouseUp:
            menu.popUp(
                positioning: nil,
                at: NSPoint(x: 0, y: sender.bounds.height + 8),
                in: sender
            )
        case .leftMouseUp:
            togglePopover(sender)
        default:
            break
        }
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }

    @objc private func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(
                    relativeTo: button.bounds,
                    of: button,
                    preferredEdge: NSRectEdge.minY
                )
            }
        }
    }
}
