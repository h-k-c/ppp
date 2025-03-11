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
    @State private var showingCopyToast = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
            
            HStack {
                Text(!item.isPasswordVisible ? String(repeating: "•", count: 8) : item.password)
                    .font(AppTheme.Typography.cardContent)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    withAnimation(AppTheme.Animation.defaultSpring) {
                        toggleVisibility(item.id)
                    }
                }) {
                    Image(systemName: item.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
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
        .onTapGesture(count: 2) {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(item.password, forType: .string)
            showingCopyToast = true
        }
        .alert("确认删除", isPresented: $showingDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                deleteItem(item.id)
            }
        } message: {
            Text("是否确认删除该密码？此操作不可撤销。")
        }
        .toast(isPresenting: $showingCopyToast, duration: 1.5, alignment: .center) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .imageScale(.large)
                Text("已复制密码")
                    .foregroundStyle(.primary)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.background)
                    .shadow(
                        color: .black.opacity(0.1),
                        radius: 10,
                        x: 0,
                        y: 4
                    )
            )
        }
    }
}

// MARK: - Toast View Modifier
extension View {
    func toast(isPresenting: Binding<Bool>, duration: TimeInterval = 2, alignment: Alignment = .top, content: @escaping () -> some View) -> some View {
        self.modifier(ToastModifier(isPresenting: isPresenting, duration: duration, alignment: alignment, content: content))
    }
}

struct ToastModifier<ToastContent: View>: ViewModifier {
    @Binding var isPresenting: Bool
    let duration: TimeInterval
    let alignment: Alignment
    let content: () -> ToastContent
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isPresenting {
                        self.content()
                            .transition(.scale.combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isPresenting = false
                                    }
                                }
                            }
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPresenting),
                alignment: alignment
            )
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
