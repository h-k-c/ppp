import SwiftUI

/// 密码卡片组件
///
/// 用于显示单个密码项的卡片视图，支持悬停效果和密码显示/隐藏
struct PasswordCard: View {
    let item: PasswordItem
    let isHovered: Bool
    let toggleVisibility: (UUID) -> Void
    let deleteItem: (UUID) -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.note)
                    .font(AppTheme.Typography.cardTitle)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
            }
            
            Divider()
            
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
                        .foregroundStyle(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Layout.cardCornerRadius)
                .fill(.background)
                .shadow(
                    color: .black.opacity(isHovered ? 0.15 : 0.1),
                    radius: isHovered ? 12 : 8,
                    x: 0,
                    y: isHovered ? 6 : 4
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(AppTheme.Animation.hover, value: isHovered)
        .alert("确认删除", isPresented: $showingDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                deleteItem(item.id)
            }
        } message: {
            Text("是否确认删除该密码？此操作不可撤销。")
        }
    }
}

// MARK: - Previews
struct PasswordCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PasswordCard(
                item: PasswordItem(
                    note: "微信账号",
                    password: "example123"
                ),
                isHovered: false,
                toggleVisibility: { _ in },
                deleteItem: { _ in }
            )
            
            PasswordCard(
                item: PasswordItem(
                    note: "淘宝账号",
                    password: "shop456"
                ),
                isHovered: true,
                toggleVisibility: { _ in },
                deleteItem: { _ in }
            )
        }
        .padding()
        .frame(width: 300)
        .previewLayout(.sizeThatFits)
    }
} 
