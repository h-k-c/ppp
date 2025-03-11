import Foundation
import SwiftUI

// 预定义的密码分类
enum PasswordCategory: String, Codable, CaseIterable, Identifiable {
    case social = "社交账号"
    case shopping = "购物网站"
    case work = "工作相关"
    case finance = "金融账户"
    case other = "其他"
    case login = "登录账户"
    
    var id: String { rawValue }
}

struct PasswordItem: Identifiable, Codable {
    let id: UUID
    let category: PasswordCategory
    let note: String
    let password: String
    var isPasswordVisible: Bool
    
    init(id: UUID = UUID(), category: PasswordCategory = .login, note: String, password: String, isPasswordVisible: Bool = false) {
        self.id = id
        self.category = category
        self.note = note
        self.password = password
        self.isPasswordVisible = isPasswordVisible
    }
}
