import SwiftUI

/// 密码卡片组件
///
/// 用于显示单个密码项的卡片视图，支持悬停效果和密码显示/隐藏
struct PasswordCard: View {
    let item: PasswordItem
    let isHovered: Bool
    let toggleVisibility: (UUID) -> Void
    
    private var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: item.gradientColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.note)
                    .font(AppTheme.Typography.cardTitle)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "lock.fill")
                    .foregroundStyle(item.gradientColors[0].opacity(0.8))
            }
            
            Divider()
                .background(item.gradientColors[0].opacity(0.5))
            
            HStack {
                Text(item.isPasswordHidden ? String(repeating: "•", count: 8) : item.password)
                    .font(AppTheme.Typography.cardContent)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    withAnimation(AppTheme.Animation.defaultSpring) {
                        toggleVisibility(item.id)
                    }
                }) {
                    Image(systemName: item.isPasswordHidden ? "eye" : "eye.slash")
                        .foregroundColor(item.gradientColors[0].opacity(0.8))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Layout.cardCornerRadius)
                .fill(gradient)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Layout.cardCornerRadius)
                        .strokeBorder(item.gradientColors[0].opacity(0.3))
                )
                .shadow(
                    color: item.gradientColors[0].opacity(isHovered ? 0.3 : 0.2),
                    radius: isHovered ? 8 : 4,
                    x: 0,
                    y: isHovered ? 4 : 2
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(AppTheme.Animation.hover, value: isHovered)
    }
}

// MARK: - Previews
struct PasswordCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PasswordCard(
                item: PasswordItem(
                    category: PasswordCategory.social.rawValue,
                    note: "微信账号",
                    password: "example123"
                ),
                isHovered: false
            ) { _ in }
            
            PasswordCard(
                item: PasswordItem(
                    category: PasswordCategory.shopping.rawValue,
                    note: "淘宝账号",
                    password: "shop456"
                ),
                isHovered: true
            ) { _ in }
        }
        .padding()
        .frame(width: 300)
        .previewLayout(.sizeThatFits)
    }
} 