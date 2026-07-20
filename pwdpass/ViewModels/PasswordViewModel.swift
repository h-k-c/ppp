import Foundation
import SwiftUI
import OSLog

private let logger = Logger(subsystem: "com.note.hkc.pwdpass", category: "ViewModel")

/// 默认分类列表
let defaultCategories = [
    "登录账户",
    "社交账号",
    "购物网站",
    "工作相关",
    "金融账户",
    "其他"
]

class PasswordViewModel: ObservableObject {
    @Published private(set) var passwordItems: [PasswordItem] = []
    @Published private(set) var categories: [String] = []
    @Published var errorAlert: String?

    private let storage = StorageManager.shared

    init() {
        loadCategories()
        loadPasswords()
    }

    // MARK: - Category Management

    private func loadCategories() {
        if let saved = storage.loadCategories(), !saved.isEmpty {
            categories = saved
        } else {
            categories = defaultCategories
            storage.saveCategories(categories)
        }
    }

    func addCategory(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !categories.contains(trimmed) else { return }
        categories.append(trimmed)
        storage.saveCategories(categories)
    }

    func renameCategory(from oldName: String, to newName: String) {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != oldName, !categories.contains(trimmed) else { return }
        guard let index = categories.firstIndex(of: oldName) else { return }
        categories[index] = trimmed
        for i in passwordItems.indices where passwordItems[i].category == oldName {
            passwordItems[i].category = trimmed
        }
        saveToStorage()
        storage.saveCategories(categories)
    }

    func removeCategory(_ name: String) {
        guard categories.count > 1 else { return }
        categories.removeAll { $0 == name }
        for i in passwordItems.indices where passwordItems[i].category == name {
            passwordItems[i].category = "其他"
        }
        saveToStorage()
        storage.saveCategories(categories)
    }

    // MARK: - Password Management

    private func loadPasswords() {
        do {
            passwordItems = try storage.loadPasswordsWithError()
        } catch {
            logger.error("加载密码失败: \(error.localizedDescription)")
            errorAlert = "加载密码数据失败，请检查存储权限或数据是否损坏。"
        }
    }

    func addPassword(_ item: PasswordItem) {
        var newItem = item
        newItem.isPasswordVisible = false
        passwordItems.append(newItem)
        saveToStorage()
    }

    func updatePassword(_ item: PasswordItem) {
        guard let index = passwordItems.firstIndex(where: { $0.id == item.id }) else {
            logger.warning("更新密码失败：未找到 ID \(item.id)")
            return
        }
        var updated = item
        updated.isPasswordVisible = false
        passwordItems[index] = updated
        saveToStorage()
    }

    func deletePassword(for id: UUID) {
        passwordItems.removeAll { $0.id == id }
        saveToStorage()
    }

    func togglePasswordVisibility(for id: UUID) {
        if let index = passwordItems.firstIndex(where: { $0.id == id }) {
            var item = passwordItems[index]
            item.isPasswordVisible.toggle()
            passwordItems[index] = item
        }
    }

    private func saveToStorage() {
        do {
            try storage.savePasswordsWithError(passwordItems)
        } catch {
            logger.error("保存密码失败: \(error.localizedDescription)")
            errorAlert = "保存密码数据失败，请检查磁盘空间或存储权限。"
        }
    }
}
