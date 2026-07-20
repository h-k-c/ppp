import SwiftUI

/// 密码卡片组件
struct PasswordCard: View {
    let item: PasswordItem
    let isHovered: Bool
    let toggleVisibility: (UUID) -> Void
    let deleteItem: (UUID) -> Void

    @State private var showingDeleteAlert = false
    @State private var showingCopyToast = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Card content
            VStack(alignment: .leading, spacing: 0) {
                categoryBadge
                    .padding(.bottom, AppTheme.Spacing.sm)

                titleRow
                    .padding(.bottom, AppTheme.Spacing.xs)

                passwordRow
            }
            .padding(AppTheme.Spacing.md)
            .background(cardBackground)
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(AppTheme.Animation.hover, value: isHovered)
            .zIndex(0)

            // Toast overlay
            if showingCopyToast {
                copyToast
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, AppTheme.Spacing.sm)
                    .zIndex(1)
            }
        }
        .animation(AppTheme.Animation.toastSpring, value: showingCopyToast)
        .onTapGesture(count: 2) {
            copyPassword()
        }
        .alert("确认删除", isPresented: $showingDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                deleteItem(item.id)
            }
        } message: {
            Text("是否确认删除该密码？此操作不可撤销。")
        }
    }

    // MARK: - Category Badge

    private var categoryBadge: some View {
        Text(item.category)
            .font(AppTheme.Typography.caption)
            .foregroundColor(AppTheme.Colors.primary)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.horizontal, AppTheme.Spacing.sm + 2)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Rounded.sm)
                    .fill(AppTheme.Colors.primary.opacity(0.1))
            )
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Title Row

    private var titleRow: some View {
        HStack(spacing: 0) {
            Text(item.note)
                .font(AppTheme.Typography.cardTitle)
                .foregroundColor(AppTheme.Colors.onSurface)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer(minLength: AppTheme.Spacing.sm)
            Button(action: { showingDeleteAlert = true }) {
                Image(systemName: "trash")
                    .font(.system(size: 12))
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.6))
            }
            .buttonStyle(.plain)
            .help("删除")
        }
    }

    // MARK: - Password Row

    private var passwordRow: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            HStack(spacing: 0) {
                Text(!item.isPasswordVisible
                     ? String(repeating: "•", count: 12)
                     : item.password)
                    .font(AppTheme.Typography.cardContentMono)
                    .foregroundColor(AppTheme.Colors.onSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .animation(AppTheme.Animation.spring, value: item.isPasswordVisible)
                Spacer(minLength: 4)
            }
            .frame(maxWidth: .infinity)

            Button(action: {
                withAnimation(AppTheme.Animation.spring) {
                    toggleVisibility(item.id)
                }
            }) {
                Image(systemName: item.isPasswordVisible
                      ? "eye.slash.fill"
                      : "eye.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.6))
            }
            .buttonStyle(.plain)
            .help(item.isPasswordVisible ? "隐藏密码" : "显示密码")
        }
    }

    // MARK: - Card Background

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: AppTheme.Rounded.default)
            .fill(AppTheme.Colors.surface)
            .shadow(
                color: .black.opacity(isHovered ? 0.12 : 0.05),
                radius: isHovered ? 24 : 4,
                x: 0,
                y: isHovered ? 6 : 2
            )
            .animation(AppTheme.Animation.hover, value: isHovered)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Rounded.default)
                    .stroke(AppTheme.Colors.outlineVariant.opacity(0.4), lineWidth: 0.5)
            )
    }

    // MARK: - Copy Toast

    private var copyToast: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(AppTheme.Colors.success)
            Text("已复制")
                .font(AppTheme.Typography.bodyRegular)
                .foregroundStyle(AppTheme.Colors.onSurface)
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.sm + 2)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Rounded.lg)
                .fill(AppTheme.Colors.surface)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }

    private func copyPassword() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item.password, forType: .string)
        showingCopyToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showingCopyToast = false
        }
    }
}

// MARK: - Previews

struct PasswordCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PasswordCard(
                item: PasswordItem(
                    category: "社交账号",
                    note: "微信账号",
                    password: "example123"
                ),
                isHovered: false,
                toggleVisibility: { _ in },
                deleteItem: { _ in }
            )

            PasswordCard(
                item: PasswordItem(
                    category: "购物网站",
                    note: "淘宝账号",
                    password: "shop456"
                ),
                isHovered: true,
                toggleVisibility: { _ in },
                deleteItem: { _ in }
            )
        }
        .padding()
        .frame(width: 420)
        .previewLayout(.sizeThatFits)
    }
}
