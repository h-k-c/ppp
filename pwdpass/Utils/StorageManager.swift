import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let fileManager = FileManager.default
    
    private var storageURL: URL? {
        guard let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let bundleID = Bundle.main.bundleIdentifier ?? "com.app.pwdpass"
        let appFolder = appSupport.appendingPathComponent(bundleID)
        
        // 创建应用文件夹
        if !fileManager.fileExists(atPath: appFolder.path) {
            try? fileManager.createDirectory(at: appFolder, withIntermediateDirectories: true)
        }
        
        return appFolder.appendingPathComponent("passwords.data")
    }
    
    // 保存密码数据
    func savePasswords(_ items: [PasswordItem]) {
        guard let url = storageURL else { return }
        
        do {
            let encodedItems = try items.map { item -> StoredPasswordItem in
                let encryptedPassword = try CryptoManager.encrypt(item.password)
                return StoredPasswordItem(
                    id: item.id,
                    category: item.category,
                    note: item.note,
                    encryptedPassword: encryptedPassword
                )
            }
            
            let data = try JSONEncoder().encode(encodedItems)
            try data.write(to: url)
        } catch {
            print("保存密码失败: \(error)")
        }
    }
    
    // 读取密码数据
    func loadPasswords() -> [PasswordItem] {
        guard let url = storageURL,
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        do {
            let storedItems = try JSONDecoder().decode([StoredPasswordItem].self, from: data)
            return try storedItems.map { stored -> PasswordItem in
                let decryptedPassword = try CryptoManager.decrypt(stored.encryptedPassword)
                return PasswordItem(
                    id: stored.id,
                    category: stored.category,
                    note: stored.note,
                    password: decryptedPassword
                )
            }
        } catch {
            print("读取密码失败: \(error)")
            return []
        }
    }
}

// 用于存储的密码项模型
private struct StoredPasswordItem: Codable {
    let id: UUID
    let category: PasswordCategory
    let note: String
    let encryptedPassword: Data
} 