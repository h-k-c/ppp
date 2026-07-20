import SwiftUI

// MARK: - Color Extensions

extension NSColor {
    convenience init(hex: UInt64) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1.0
        )
    }

    static func dynamic(light: UInt64, dark: UInt64) -> NSColor {
        NSColor(name: nil) { appearance in
            let isDark: Bool
            switch appearance.name {
            case .darkAqua, .vibrantDark,
                .accessibilityHighContrastDarkAqua,
                .accessibilityHighContrastVibrantDark:
                isDark = true
            default:
                isDark = false
            }
            return NSColor(hex: isDark ? dark : light)
        }
    }
}

extension Color {
    init(hex: UInt64) {
        self.init(nsColor: NSColor(hex: hex))
    }

    init(light: UInt64, dark: UInt64) {
        self.init(nsColor: NSColor.dynamic(light: light, dark: dark))
    }
}

// MARK: - Design System

/// Native Utility System — 完整设计语言
enum AppTheme {

    // MARK: - Colors

    enum Colors {
        // Surface
        static let surface = Color(light: 0xFCF8FB, dark: 0x2D2D2D)
        static let surfaceDim = Color(light: 0xDCD9DC, dark: 0x1E1E1E)
        static let surfaceBright = Color(light: 0xFCF8FB, dark: 0x3A3A3A)
        static let surfaceContainerLowest = Color(light: 0xFFFFFF, dark: 0x1A1A1A)
        static let surfaceContainerLow = Color(light: 0xF6F3F5, dark: 0x252525)
        static let surfaceContainer = Color(light: 0xF0EDEF, dark: 0x2D2D2D)
        static let surfaceContainerHigh = Color(light: 0xEAE7EA, dark: 0x353535)
        static let surfaceContainerHighest = Color(light: 0xE4E2E4, dark: 0x3D3D3D)

        static let onSurface = Color(light: 0x1B1B1D, dark: 0xE6E0E3)
        static let onSurfaceVariant = Color(light: 0x414755, dark: 0xC4C0C3)

        // Primary
        static let primary = Color(light: 0x0058BC, dark: 0xADC6FF)
        static let onPrimary = Color(light: 0xFFFFFF, dark: 0x001A41)
        static let primaryContainer = Color(light: 0x0070EB, dark: 0x004493)
        static let inversePrimary = Color(light: 0xADC6FF, dark: 0x0058BC)

        // Secondary
        static let secondary = Color(light: 0x5D5E63, dark: 0xC6C6CB)
        static let onSecondary = Color(light: 0xFFFFFF, dark: 0x1A1B1F)
        static let secondaryContainer = Color(light: 0xE0DFE4, dark: 0x46464B)

        // Tertiary / Success
        static let tertiary = Color(light: 0x006B27, dark: 0x53E16F)
        static let onTertiary = Color(light: 0xFFFFFF, dark: 0x002107)
        static let tertiaryContainer = Color(light: 0x008733, dark: 0x00531C)

        // Error
        static let error = Color(light: 0xBA1A1A, dark: 0xFFB4AB)
        static let onError = Color(light: 0xFFFFFF, dark: 0x690005)
        static let errorContainer = Color(light: 0xFFDAD6, dark: 0x93000A)

        // Outline
        static let outline = Color(light: 0x717786, dark: 0x8E9099)
        static let outlineVariant = Color(light: 0xC1C6D7, dark: 0x44474E)

        // Tint
        static let surfaceTint = Color(light: 0x005BC1, dark: 0xADC6FF)

        // Functional aliases
        static let accent = Color(light: 0x007AFF, dark: 0x0A84FF)
        static let destructive = Color(light: 0xFF3B30, dark: 0xFF453A)
        static let success = Color(light: 0x34C759, dark: 0x30D158)
        static let warning = Color(light: 0xFF9500, dark: 0xFF9F0A)
    }

    // MARK: - Typography

    enum Typography {
        /// 20px Bold — 模态标题
        static let headlineLg = Font.custom("Inter-Bold", size: 20)

        /// 14px Semibold — 段落标题
        static let headerSemibold = Font.custom("Inter-SemiBold", size: 14)

        /// 13px Semibold — 卡片标题
        static let cardTitle = Font.custom("Inter-SemiBold", size: 13)

        /// 13px Regular — 正文
        static let bodyRegular = Font.custom("Inter-Regular", size: 13)

        /// 12px Regular — 密码/数据内容
        static let cardContentMono = Font.custom("JetBrainsMono-Regular", size: 12)

        /// 11px Regular — 辅助说明
        static let caption = Font.custom("Inter-Regular", size: 11)

        /// 11px Semibold — 分类标签
        static let pill = Font.custom("Inter-SemiBold", size: 11)
    }

    // MARK: - Spacing

    enum Spacing {
        static let unit: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24

        /// Window horizontal padding
        static let windowH: CGFloat = 14
        /// Window vertical padding
        static let windowV: CGFloat = 10
        /// Grid gutter
        static let gutter: CGFloat = 10
    }

    // MARK: - Corner Radius

    enum Rounded {
        static let sm: CGFloat = 4
        static let `default`: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let full: CGFloat = 9999
    }

    // MARK: - Animation

    enum Animation {
        static let spring = SwiftUI.Animation.spring(
            response: 0.3,
            dampingFraction: 0.7
        )
        static let quickSpring = SwiftUI.Animation.spring(
            response: 0.2,
            dampingFraction: 0.7
        )
        static let hover = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let toastSpring = SwiftUI.Animation.spring(
            response: 0.4,
            dampingFraction: 0.65
        )
    }

    // MARK: - Layout

    enum Layout {
        static let popoverWidth: CGFloat = 380
        static let popoverHeight: CGFloat = 440
        static let cardMinWidth: CGFloat = 180
        static let categoryPillHeight: CGFloat = 28
        static let searchHeight: CGFloat = 32
        static let iconSize: CGFloat = 16
    }
}
