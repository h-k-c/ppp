import Foundation

struct PasswordItem: Identifiable, Codable {
    let id: UUID
    var category: String
    let note: String
    let password: String
    var isPasswordVisible: Bool

    init(id: UUID = UUID(), category: String = "登录账户", note: String, password: String, isPasswordVisible: Bool = false) {
        self.id = id
        self.category = category
        self.note = note
        self.password = password
        self.isPasswordVisible = isPasswordVisible
    }
}
