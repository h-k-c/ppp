import SwiftUI

/// 分类标签组件
///
/// 用于显示密码分类的可选择标签，支持选中状态和动画效果
struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.categoryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(height: AppTheme.Layout.categoryPillHeight)
                .background(
                    Capsule()
                        .fill(isSelected ? AppTheme.Colors.accent.opacity(0.2) : Color.clear)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? AppTheme.Colors.accent : Color.gray.opacity(0.3),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
                .foregroundColor(isSelected ? AppTheme.Colors.accent : .primary)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .shadow(
            color: isSelected ? AppTheme.Colors.accent.opacity(0.2) : .clear,
            radius: 4
        )
        .animation(AppTheme.Animation.quickSpring, value: isSelected)
    }
}

// MARK: - Previews
struct CategoryPill_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CategoryPill(title: "社交账号", isSelected: true) {}
            CategoryPill(title: "购物网站", isSelected: false) {}
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

