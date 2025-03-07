import Foundation
import SwiftUI

class PasswordViewModel: ObservableObject {
    @Published var passwordItems: [PasswordItem] = []
    @Published var selectedCategory: String = PasswordCategory.social.rawValue
    
    init() {
        // 添加一些示例数据
        passwordItems = [
            PasswordItem(category: PasswordCategory.social.rawValue, note: "微信账号", password: "example123"),
            PasswordItem(category: PasswordCategory.social.rawValue, note: "QQ账号", password: "qq123456"),
            PasswordItem(category: PasswordCategory.shopping.rawValue, note: "淘宝账号", password: "shop456"),
            PasswordItem(category: PasswordCategory.shopping.rawValue, note: "京东账号", password: "jd789"),
            PasswordItem(category: PasswordCategory.work.rawValue, note: "公司邮箱", password: "work789"),
            PasswordItem(category: PasswordCategory.work.rawValue, note: "工作平台", password: "platform123"),
            PasswordItem(category: PasswordCategory.finance.rawValue, note: "支付宝", password: "alipay123"),
            PasswordItem(category: PasswordCategory.finance.rawValue, note: "网银", password: "bank456")
        ]
    }
    
    func getPasswordsByCategory(_ category: String) -> [PasswordItem] {
        return passwordItems.filter { $0.category == category }
    }
    
    func addPassword(_ item: PasswordItem) {
        passwordItems.append(item)
        objectWillChange.send()
    }
    
    func togglePasswordVisibility(for itemId: UUID) {
        if let index = passwordItems.firstIndex(where: { $0.id == itemId }) {
            passwordItems[index].isPasswordHidden.toggle()
            objectWillChange.send()
        }
    }
    
    func deletePassword(for itemId: UUID) {
        passwordItems.removeAll { $0.id == itemId }
        objectWillChange.send()
    }
    
    func updatePassword(_ updatedItem: PasswordItem) {
        if let index = passwordItems.firstIndex(where: { $0.id == updatedItem.id }) {
            passwordItems[index] = updatedItem
            objectWillChange.send()
        }
    }
} 