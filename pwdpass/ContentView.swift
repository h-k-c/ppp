import SwiftUI

/// 主视图
struct ContentView: View {
    @StateObject private var viewModel = PasswordViewModel()
    @State private var hoveredCardId: UUID?
    @State private var showingAddSheet = false
    @State private var searchText = ""
    @State private var selectedCategory: String?
    @State private var showingCategoryManage = false
    @State private var editingItem: PasswordItem?

    private var filteredItems: [PasswordItem] {
        var items = viewModel.passwordItems
        if !searchText.isEmpty {
            items = items.filter { $0.note.localizedCaseInsensitiveContains(searchText) }
        }
        if let category = selectedCategory {
            items = items.filter { $0.category == category }
        }
        return items
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
            categoryPillsView
                .padding(.bottom, AppTheme.Spacing.md)
            searchBarView
                .padding(.bottom, AppTheme.Spacing.md)

            if viewModel.passwordItems.isEmpty {
                emptyStateView
            } else if filteredItems.isEmpty {
                noResultsView
            } else {
                cardGrid
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddPasswordSheet(
                categories: viewModel.categories,
                onAddCategory: { viewModel.addCategory($0) },
                onDeleteCategory: { viewModel.removeCategory($0) },
                onSave: { viewModel.addPassword($0) }
            )
        }
        .sheet(item: $editingItem) { item in
            AddPasswordSheet(
                categories: viewModel.categories,
                onAddCategory: { viewModel.addCategory($0) },
                onDeleteCategory: { viewModel.removeCategory($0) },
                onSave: { viewModel.updatePassword($0) },
                editingItem: item
            )
        }
        .sheet(isPresented: $showingCategoryManage) {
            CategoryManageSheet(viewModel: viewModel)
        }
        .alert("错误", isPresented: .init(
            get: { viewModel.errorAlert != nil },
            set: { if !$0 { viewModel.errorAlert = nil } }
        )) {
            Button("确定") { viewModel.errorAlert = nil }
        } message: {
            Text(viewModel.errorAlert ?? "")
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: 0) {
            Text("嗅密")
                .font(AppTheme.Typography.headlineLg)
                .foregroundColor(AppTheme.Colors.onSurface)
            Spacer()
            Button(action: { showingAddSheet = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(AppTheme.Colors.accent)
            }
            .buttonStyle(.plain)
            .help("新增密码")
        }
        .padding(.bottom, AppTheme.Spacing.lg)
    }

    // MARK: - Category Pills

    private var categoryPillsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                pillView(title: "全部", isSelected: selectedCategory == nil)
                    .onTapGesture { selectedCategory = nil }

                ForEach(viewModel.categories, id: \.self) { category in
                    pillView(title: category, isSelected: selectedCategory == category)
                        .onTapGesture { selectedCategory = category }
                }

                Button(action: { showingCategoryManage = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.5))
                        .frame(width: 26, height: 26)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.Rounded.full)
                                .stroke(AppTheme.Colors.outlineVariant, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .help("管理分类")
            }
            .padding(.horizontal, 2)
        }
    }

    private func pillView(title: String, isSelected: Bool) -> some View {
        Text(title)
            .font(AppTheme.Typography.pill)
            .foregroundColor(isSelected
                ? AppTheme.Colors.onPrimary
                : AppTheme.Colors.onSurfaceVariant)
            .padding(.horizontal, AppTheme.Spacing.md)
            .frame(height: AppTheme.Layout.categoryPillHeight)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Rounded.full)
                    .fill(isSelected
                        ? AppTheme.Colors.primary
                        : AppTheme.Colors.surfaceContainerHigh)
            )
            .animation(AppTheme.Animation.hover, value: isSelected)
    }

    // MARK: - Search Bar

    private var searchBarView: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13))
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant)
            TextField("搜索密码", text: $searchText)
                .textFieldStyle(.plain)
                .font(AppTheme.Typography.bodyRegular)
                .foregroundColor(AppTheme.Colors.onSurface)
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(searchText.isEmpty
                    ? Color.clear
                    : AppTheme.Colors.onSurfaceVariant)
                .onTapGesture { searchText = "" }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .frame(height: AppTheme.Layout.searchHeight)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Rounded.xl)
                .fill(AppTheme.Colors.surfaceContainerHigh)
        )
    }

    // MARK: - Empty States

    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "key.icloud")
                .font(.system(size: 32))
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.4))
            Text("暂无密码")
                .font(AppTheme.Typography.bodyRegular)
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.6))
            Text("点击 \"+\" 添加第一个密码")
                .font(AppTheme.Typography.caption)
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.4))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var noResultsView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 32))
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.4))
            Text("未找到相关密码")
                .font(AppTheme.Typography.bodyRegular)
                .foregroundStyle(AppTheme.Colors.onSurfaceVariant.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Card Grid

    private var cardGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: AppTheme.Spacing.gutter),
                    GridItem(.flexible(), spacing: AppTheme.Spacing.gutter)
                ],
                spacing: AppTheme.Spacing.gutter
            ) {
                ForEach(filteredItems) { item in
                    PasswordCard(
                        item: item,
                        isHovered: hoveredCardId == item.id,
                        toggleVisibility: { viewModel.togglePasswordVisibility(for: $0) },
                        deleteItem: { viewModel.deletePassword(for: $0) }
                    )
                    .onHover { isHovered in
                        withAnimation(AppTheme.Animation.hover) {
                            hoveredCardId = isHovered ? item.id : nil
                        }
                    }
                    .contextMenu {
                        Button("复制密码") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(item.password, forType: .string)
                        }
                        Button("编辑") {
                            editingItem = item
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.top, AppTheme.Spacing.xs)
        }
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
