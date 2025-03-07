import SwiftUI

/// 应用主题配置
enum AppTheme {
    /// 颜色配置
    enum Colors {
        static let categoryGradients: [PasswordCategory: [Color]] = [
            .social: [.blue, .purple],
            .shopping: [.orange, .pink],
            .work: [.green, .blue],
            .finance: [.purple, .red],
            .other: [.gray, .blue]
        ]
        
        static let cardGradients: [[Color]] = [
            [.blue.opacity(0.8), .purple.opacity(0.8)],
            [.orange.opacity(0.8), .pink.opacity(0.8)],
            [.green.opacity(0.8), .blue.opacity(0.8)],
            [.purple.opacity(0.8), .red.opacity(0.8)],
            [.indigo.opacity(0.8), .blue.opacity(0.8)],
            [.pink.opacity(0.8), .purple.opacity(0.8)],
            [.mint.opacity(0.8), .green.opacity(0.8)],
            [.orange.opacity(0.8), .red.opacity(0.8)],
            [.teal.opacity(0.8), .blue.opacity(0.8)],
            [.purple.opacity(0.8), .indigo.opacity(0.8)]
        ]
        
        static func randomCardGradient() -> [Color] {
            cardGradients.randomElement() ?? [.gray, .blue]
        }
        
        static let accent = Color.blue
        static let background = Color(NSColor.windowBackgroundColor)
    }
    
    /// 动画配置
    enum Animation {
        static let defaultSpring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
        static let quickSpring = SwiftUI.Animation.spring(response: 0.2, dampingFraction: 0.7)
        static let hover = SwiftUI.Animation.easeInOut(duration: 0.2)
    }
    
    /// 布局尺寸配置
    enum Layout {
        static let cardMinWidth: CGFloat = 120
        static let cardMaxWidth: CGFloat = 150
        static let cardSpacing: CGFloat = 12
        static let cardCornerRadius: CGFloat = 10
        
        static let categoryPillHeight: CGFloat = 28
        static let categorySpacing: CGFloat = 10
    }
    
    /// 文字样式配置
    enum Typography {
        static let categoryText = Font.system(size: 12, weight: .medium)
        static let cardTitle = Font.system(size: 13, weight: .semibold)
        static let cardContent = Font.system(size: 12, design: .monospaced)
    }
} 