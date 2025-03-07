//
//  ContentView.swift
//  pwdpass
//
//  Created by 胡开成 on 2025/3/7.
//

import SwiftUI

/// 主视图
///
/// 应用的主界面，包含分类选择和密码列表展示
struct ContentView: View {
    @StateObject private var viewModel = PasswordViewModel()
    @State private var hoveredCardId: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            categorySection
            passwordGridSection
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                addPasswordButton
            }
        }
    }
    
    // MARK: - View Components
    
    /// 分类选择区域
    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Layout.categorySpacing) {
                ForEach(PasswordCategory.allCases, id: \.self) { category in
                    CategoryPill(
                        title: category.rawValue,
                        isSelected: viewModel.selectedCategory == category.rawValue
                    ) {
                        withAnimation(AppTheme.Animation.defaultSpring) {
                            viewModel.selectedCategory = category.rawValue
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(.ultraThinMaterial)
    }
    
    /// 密码网格区域
    private var passwordGridSection: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: AppTheme.Layout.cardMinWidth, maximum: AppTheme.Layout.cardMaxWidth), spacing: AppTheme.Layout.cardSpacing)
            ], spacing: AppTheme.Layout.cardSpacing) {
                ForEach(viewModel.getPasswordsByCategory(viewModel.selectedCategory)) { item in
                    passwordCard(for: item)
                }
            }
            .padding()
            .animation(AppTheme.Animation.defaultSpring, value: viewModel.selectedCategory)
        }
        .background(
            ZStack {
                AppTheme.Colors.background
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
        )
    }
    
    /// 创建密码卡片视图
    private func passwordCard(for item: PasswordItem) -> some View {
        PasswordCard(
            item: item,
            isHovered: hoveredCardId == item.id
        ) { id in
            viewModel.togglePasswordVisibility(for: id)
        }
        .onHover { isHovered in
            withAnimation(AppTheme.Animation.hover) {
                hoveredCardId = isHovered ? item.id : nil
            }
        }
        .contextMenu {
            Button(action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(item.password, forType: .string)
            }) {
                Text("复制密码")
                Image(systemName: "doc.on.doc")
            }
            
            Button(action: {
                // TODO: 实现编辑功能
            }) {
                Text("编辑")
                Image(systemName: "pencil")
            }
            
            Button(action: {
                viewModel.deletePassword(for: item.id)
            }) {
                Text("删除")
                Image(systemName: "trash")
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    /// 添加密码按钮
    private var addPasswordButton: some View {
        Button(action: {
            // TODO: 实现添加新密码功能
        }) {
            Image(systemName: "plus.circle.fill")
                .foregroundStyle(AppTheme.Colors.accent)
                .imageScale(.large)
        }
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

