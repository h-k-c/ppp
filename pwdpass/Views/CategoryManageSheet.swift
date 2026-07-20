import SwiftUI

/// 分类管理页面 — 增删改
struct CategoryManageSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PasswordViewModel

    @State private var newName = ""
    @State private var renameTarget: String? = nil
    @State private var renameText = ""
    @State private var deleteTarget: String? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("管理分类")
                    .font(AppTheme.Typography.headerSemibold)
                    .foregroundColor(AppTheme.Colors.onSurface)
                Spacer()
                Button("完成") { dismiss() }
                    .font(AppTheme.Typography.bodyRegular)
                    .foregroundColor(AppTheme.Colors.accent)
                    .buttonStyle(.plain)
            }
            .padding(.bottom, AppTheme.Spacing.lg)

            // Add new
            HStack(spacing: AppTheme.Spacing.sm) {
                TextField("新分类名称", text: $newName)
                    .textFieldStyle(.plain)
                    .font(AppTheme.Typography.bodyRegular)
                    .foregroundColor(AppTheme.Colors.onSurface)
                    .padding(.horizontal, 10)
                    .frame(height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.Rounded.sm)
                            .fill(AppTheme.Colors.surfaceContainerHigh)
                    )
                Button("添加") {
                    let trimmed = newName.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    viewModel.addCategory(trimmed)
                    newName = ""
                }
                .font(AppTheme.Typography.bodyRegular)
                .foregroundColor(AppTheme.Colors.primary)
                .buttonStyle(.plain)
                .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.bottom, AppTheme.Spacing.md)

            // List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        categoryRow(category)
                        if category != viewModel.categories.last {
                            Divider()
                                .padding(.leading, 40)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Rounded.md)
                        .fill(AppTheme.Colors.surface)
                )
            }

            // Footer hint
            if viewModel.passwordItems.count > 0 {
                Text("删除分类后，该分类下的密码将移至\"其他\"")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.onSurfaceVariant.opacity(0.6))
                    .padding(.top, AppTheme.Spacing.sm)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .frame(width: 360, height: 380)
        .background(AppTheme.Colors.surfaceDim)
        .alert("确认删除", isPresented: .init(
            get: { deleteTarget != nil },
            set: { if !$0 { deleteTarget = nil } }
        )) {
            Button("取消", role: .cancel) { deleteTarget = nil }
            Button("删除", role: .destructive) {
                if let target = deleteTarget {
                    viewModel.removeCategory(target)
                }
                deleteTarget = nil
            }
        } message: {
            Text("删除「\(deleteTarget ?? "")」后，该分类下的密码将移至\"其他\"")
        }
    }

    @ViewBuilder
    private func categoryRow(_ category: String) -> some View {
        if renameTarget == category {
            // Renaming mode
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "pencil")
                    .font(.system(size: 12))
                    .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.4))
                    .frame(width: 20)

                TextField("分类名称", text: $renameText)
                    .textFieldStyle(.plain)
                    .font(AppTheme.Typography.bodyRegular)
                    .foregroundColor(AppTheme.Colors.onSurface)
                    .padding(.horizontal, 8)
                    .frame(height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.Rounded.sm)
                            .fill(AppTheme.Colors.surfaceContainerHigh)
                    )

                Button("保存") {
                    let trimmed = renameText.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty, trimmed != category {
                        viewModel.renameCategory(from: category, to: trimmed)
                    }
                    renameTarget = nil
                }
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.primary)
                .buttonStyle(.plain)

                Button("取消") {
                    renameTarget = nil
                }
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.onSurfaceVariant)
                .buttonStyle(.plain)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, AppTheme.Spacing.md)
        } else {
            // Normal display
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "folder.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(AppTheme.Colors.primary)
                    .frame(width: 20)

                Text(category)
                    .font(AppTheme.Typography.bodyRegular)
                    .foregroundColor(AppTheme.Colors.onSurface)

                Spacer()

                Button("重命名") {
                    renameTarget = category
                    renameText = category
                }
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.onSurfaceVariant)
                .buttonStyle(.plain)

                Button("删除") {
                    deleteTarget = category
                }
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.destructive)
                .buttonStyle(.plain)
                .disabled(viewModel.categories.count <= 1)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, AppTheme.Spacing.md)
        }
    }
}

// MARK: - Previews

struct CategoryManageSheet_Previews: PreviewProvider {
    static var previews: some View {
        CategoryManageSheet(viewModel: PasswordViewModel())
    }
}
