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
    @State private var searchText = ""
    
    private var filteredItems: [PasswordItem] {
        if searchText.isEmpty {
            return viewModel.passwordItems
        }
        return viewModel.passwordItems.filter { $0.note.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部工具栏
            HStack {
                Text("密码管理器")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Button(action: {
                    showingAddSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(AppTheme.Colors.accent)
                        .imageScale(.medium)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 10)
            
            // 搜索框
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .imageScale(.small)
                TextField("搜索密码", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .imageScale(.small)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(.secondary.opacity(0.1))
            )
            .padding(.bottom, 12)
            
            if filteredItems.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 28))
                        .foregroundStyle(.secondary)
                    Text("未找到相关密码")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // 密码列表
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: AppTheme.Layout.cardSpacing),
                        GridItem(.flexible(), spacing: AppTheme.Layout.cardSpacing)
                    ], spacing: AppTheme.Layout.cardSpacing) {
                        ForEach(filteredItems) { item in
                            passwordCard(for: item)
                        }
                    }
                    .padding(.top, 2)
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddPasswordSheet { newItem in
                viewModel.addPassword(newItem)
            }
        }
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
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

