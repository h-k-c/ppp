import Foundation
import SwiftUI

class PasswordViewModel: ObservableObject {
    @Published private(set) var passwordItems: [PasswordItem] = []
    private let storage = StorageManager.shared
    
    init() {
        // 从存储加载数据
        passwordItems = storage.loadPasswords()
    }
    
    func addPassword(_ item: PasswordItem) {
        var newItem = item
        newItem.isPasswordVisible = false
        passwordItems.append(newItem)
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
        storage.savePasswords(passwordItems)
    }
} 
