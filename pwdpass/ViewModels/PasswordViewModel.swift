import Foundation
import SwiftUI

class PasswordViewModel: ObservableObject {
    @Published var passwordItems: [PasswordItem] = []
    
    init() {
        // 添加一些示例数据
        passwordItems = [
            PasswordItem(note: "微信账号", password: "example123"),
            PasswordItem(note: "QQ账号", password: "qq123456"),
            PasswordItem(note: "淘宝账号", password: "shop456"),
            PasswordItem(note: "京东账号", password: "jd789"),
            PasswordItem(note: "公司邮箱", password: "work789"),
            PasswordItem(note: "工作平台", password: "platform123"),
            PasswordItem(note: "支付宝", password: "alipay123"),
            PasswordItem(note: "网银", password: "bank456")
        ]
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