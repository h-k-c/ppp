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
    @State private var showingAddSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            passwordGridSection
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                addPasswordButton
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddPasswordSheet { newItem in
                viewModel.addPassword(newItem)
            }
        }
    }
    
    /// 密码网格区域
    private var passwordGridSection: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: AppTheme.Layout.cardMinWidth, maximum: AppTheme.Layout.cardMaxWidth), spacing: AppTheme.Layout.cardSpacing)
            ], spacing: AppTheme.Layout.cardSpacing) {
                ForEach(viewModel.passwordItems) { item in
                    passwordCard(for: item)
                }
            }
            .padding()
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
            isHovered: hoveredCardId == item.id,
            toggleVisibility: { id in
                viewModel.togglePasswordVisibility(for: id)
            },
            deleteItem: { id in
                viewModel.deletePassword(for: id)
            }
        )
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
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    /// 添加密码按钮
    private var addPasswordButton: some View {
        Button(action: {
            showingAddSheet = true
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

