import SwiftUI

struct AddPasswordSheet: View {
    @Environment(\.dismiss) private var dismiss

    let categories: [String]
    let onAddCategory: (String) -> Void
    let onDeleteCategory: (String) -> Void
    let onSave: (PasswordItem) -> Void
    var editingItem: PasswordItem? = nil

    @State private var account: String
    @State private var password: String
    @State private var showPassword = false
    @State private var selectedCategory: String
    @State private var isEditing = false
    @State private var newCategoryName = ""
    @State private var deleteTarget: String? = nil
    @State private var hoveredDeleteItem: String? = nil

    private let gridColumns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6)
    ]

    private var isEditMode: Bool { editingItem != nil }

    init(
        categories: [String],
        onAddCategory: @escaping (String) -> Void,
        onDeleteCategory: @escaping (String) -> Void,
        onSave: @escaping (PasswordItem) -> Void,
        editingItem: PasswordItem? = nil
    ) {
        self.categories = categories
        self.onAddCategory = onAddCategory
        self.onDeleteCategory = onDeleteCategory
        self.onSave = onSave
        self.editingItem = editingItem
        _account = State(initialValue: editingItem?.note ?? "")
        _password = State(initialValue: editingItem?.password ?? "")
        _selectedCategory = State(initialValue: editingItem?.category ?? (categories.first ?? "登录账户"))
    }

    var body: some View {
        VStack(spacing: 14) {
            // Header
            HStack {
                Text(isEditMode ? "编辑密码" : "新增密码")
                    .font(AppTheme.Typography.headerSemibold)
                    .foregroundColor(AppTheme.Colors.onSurface)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.5))
                }
                .buttonStyle(.plain)
            }

            // 账号
            VStack(alignment: .leading, spacing: 4) {
                Text("账号")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.onSurfaceVariant)
                TextField("输入账号名称", text: $account)
                    .textFieldStyle(.plain)
                    .font(AppTheme.Typography.bodyRegular)
                    .foregroundColor(AppTheme.Colors.onSurface)
                    .padding(.horizontal, 10)
                    .frame(height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.Rounded.sm)
                            .fill(AppTheme.Colors.surfaceContainerHigh)
                    )
            }

            // 密码
            VStack(alignment: .leading, spacing: 4) {
                Text("密码")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.onSurfaceVariant)
                HStack(spacing: 4) {
                    Group {
                        if showPassword {
                            TextField("输入密码", text: $password)
                        } else {
                            SecureField("输入密码", text: $password)
                        }
                    }
                    .textFieldStyle(.plain)
                    .font(AppTheme.Typography.bodyRegular)
                    .foregroundColor(AppTheme.Colors.onSurface)
                    .padding(.leading, 10)

                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.5))
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 10)
                }
                .frame(height: 28)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Rounded.sm)
                        .fill(AppTheme.Colors.surfaceContainerHigh)
                )
            }

            // 分类
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("分类")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.onSurfaceVariant)
                    Spacer()
                    if isEditing {
                        Button("完成") {
                            isEditing = false
                            hoveredDeleteItem = nil
                        }
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.accent)
                        .buttonStyle(.plain)
                    }
                }

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridColumns, spacing: 6) {
                        ForEach(categories, id: \.self) { cat in
                            categoryCell(cat, isSelected: selectedCategory == cat)
                                .onTapGesture {
                                    if !isEditing { selectedCategory = cat }
                                }
                                .onHover { hovering in
                                    hoveredDeleteItem = hovering ? cat : nil
                                }
                        }

                        // 编辑 / 新增按钮
                        Button(action: {
                            if isEditing {
                                isEditing = false
                            } else {
                                isEditing = true
                            }
                        }) {
                            Image(systemName: isEditing ? "checkmark" : "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
                                .frame(maxWidth: .infinity)
                                .frame(height: 28)
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.Rounded.full)
                                        .stroke(isEditing
                                            ? AppTheme.Colors.accent
                                            : AppTheme.Colors.outlineVariant,
                                            lineWidth: isEditing ? 1.5 : 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxHeight: 120)

                // 编辑模式：新增分类输入
                if isEditing {
                    HStack(spacing: 6) {
                        TextField("新分类名称", text: $newCategoryName)
                            .textFieldStyle(.plain)
                            .font(AppTheme.Typography.bodyRegular)
                            .foregroundColor(AppTheme.Colors.onSurface)
                            .padding(.horizontal, 10)
                            .frame(height: 26)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.Rounded.sm)
                                    .fill(AppTheme.Colors.surfaceContainerHigh)
                            )
                        Button("添加") {
                            let trimmed = newCategoryName.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                onAddCategory(trimmed)
                                selectedCategory = trimmed
                                newCategoryName = ""
                            }
                        }
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.primary)
                        .buttonStyle(.plain)
                        .disabled(newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }

            // Bottom buttons
            HStack(spacing: AppTheme.Spacing.md) {
                Spacer()
                Button("取消") { dismiss() }
                    .font(AppTheme.Typography.bodyRegular)
                    .foregroundColor(AppTheme.Colors.onSurfaceVariant)
                    .buttonStyle(.plain)
                    .keyboardShortcut(.escape)

                Button(isEditMode ? "更新" : "保存") {
                    guard !account.isEmpty, !password.isEmpty else { return }
                    let item = PasswordItem(
                        id: editingItem?.id ?? UUID(),
                        category: selectedCategory,
                        note: account,
                        password: password
                    )
                    onSave(item)
                    dismiss()
                }
                .font(AppTheme.Typography.headerSemibold)
                .foregroundColor(AppTheme.Colors.onPrimary)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .frame(height: 28)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Rounded.default)
                        .fill(account.isEmpty || password.isEmpty
                            ? AppTheme.Colors.primary.opacity(0.4)
                            : AppTheme.Colors.primary)
                )
                .disabled(account.isEmpty || password.isEmpty)
                .keyboardShortcut(.return)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .frame(width: 320)
        .background(AppTheme.Colors.surfaceDim)
        .alert("确认删除", isPresented: .init(
            get: { deleteTarget != nil },
            set: { if !$0 { deleteTarget = nil } }
        )) {
            Button("取消", role: .cancel) { deleteTarget = nil }
            Button("删除", role: .destructive) {
                if let target = deleteTarget {
                    onDeleteCategory(target)
                    if selectedCategory == target {
                        selectedCategory = categories.first ?? "其他"
                    }
                }
                deleteTarget = nil
            }
        } message: {
            Text("删除「\(deleteTarget ?? "")」后，该分类下的密码将移至\"其他\"")
        }
    }

    @ViewBuilder
    private func categoryCell(_ name: String, isSelected: Bool) -> some View {
        ZStack(alignment: .topTrailing) {
            Text(name)
                .font(AppTheme.Typography.pill)
                .foregroundColor(isSelected
                    ? AppTheme.Colors.onPrimary
                    : AppTheme.Colors.onSurfaceVariant)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.horizontal, 6)
                .frame(maxWidth: .infinity)
                .frame(height: 24)
                .padding(.top, isEditing ? 6 : 0)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Rounded.full)
                        .fill(isSelected
                            ? AppTheme.Colors.primary
                            : AppTheme.Colors.surfaceContainerHigh)
                )
                .animation(AppTheme.Animation.hover, value: isSelected)

            // 编辑模式下的删除按钮
            if isEditing {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(AppTheme.Colors.destructive)
                    .background(
                        Circle()
                            .fill(AppTheme.Colors.surfaceDim)
                            .frame(width: 7, height: 7)
                    )
                    .offset(x: 2, y: -2)
                    .opacity(hoveredDeleteItem == name ? 1 : 0.3)
                    .scaleEffect(hoveredDeleteItem == name ? 1 : 0.7)
                    .animation(.spring(response: 0.2, dampingFraction: 0.7), value: hoveredDeleteItem == name)
                    .onTapGesture {
                        deleteTarget = name
                    }
            }
        }
    }
}

// MARK: - Previews

struct AddPasswordSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddPasswordSheet(
            categories: ["登录账户", "社交账号", "购物网站", "工作相关"],
            onAddCategory: { _ in },
            onDeleteCategory: { _ in },
            onSave: { _ in }
        )
    }
}
