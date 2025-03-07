import SwiftUI

/// 应用主题配置
enum AppTheme {
    /// 颜色配置
    enum Colors {
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
        static let cardMinWidth: CGFloat = 180
        static let cardMaxWidth: CGFloat = 190
        static let cardSpacing: CGFloat = 10
        static let cardCornerRadius: CGFloat = 8
        
        static let categoryPillHeight: CGFloat = 28
        static let categorySpacing: CGFloat = 10
    }
    
    /// 文字样式配置
    enum Typography {
        static let cardTitle = Font.system(size: 13, weight: .semibold)
        static let cardContent = Font.system(size: 12, design: .monospaced)
    }
} 