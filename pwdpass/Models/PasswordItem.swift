import Foundation
import SwiftUI

struct PasswordItem: Identifiable, Hashable {
    let id = UUID()
    var note: String
    var password: String
    var isPasswordHidden: Bool = true
    
    init(note: String, password: String) {
        self.note = note
        self.password = password
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PasswordItem, rhs: PasswordItem) -> Bool {
        lhs.id == rhs.id
    }
}

// 预定义的密码分类
enum PasswordCategory: String, CaseIterable {
    case social = "社交账号"
    case shopping = "购物网站"
    case work = "工作相关"
    case finance = "金融账户"
    case other = "其他"
} 