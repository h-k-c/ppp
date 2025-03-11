import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let fileManager = FileManager.default
    
    private var storageDirectoryURL: URL? {
        // 获取应用程序的当前工作目录
        let currentDirectoryURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
        let pwdfileDirectory = currentDirectoryURL.appendingPathComponent("pwdfile")
        
        if !fileManager.fileExists(atPath: pwdfileDirectory.path) {
            try? fileManager.createDirectory(at: pwdfileDirectory, withIntermediateDirectories: true)
        }
        
        return pwdfileDirectory
    }
    
    private var passwordsFileURL: URL? {
        storageDirectoryURL?.appendingPathComponent("passwords.data")
    }
    
    private init() {
        setupStorageDirectory()
    }
    
    private func setupStorageDirectory() {
        guard let directoryURL = storageDirectoryURL else {
            print("无法创建存储目录")
            return
        }
        
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                print("成功创建存储目录")
            } catch {
                print("创建存储目录失败: \(error)")
            }
        }
    }
    
    func savePasswords(_ passwords: [PasswordItem]) {
        guard let fileURL = passwordsFileURL else {
            print("无法获取密码文件 URL")
            return
        }
        
        do {
            let encodedItems = try passwords.map { item -> StoredPasswordItem in
                let encryptedPassword = try CryptoManager.encrypt(item.password)
                return StoredPasswordItem(
                    id: item.id,
                    category: item.category,
                    note: item.note,
                    encryptedPassword: encryptedPassword
                )
            }
            
            let data = try JSONEncoder().encode(encodedItems)
            try data.write(to: fileURL)
            print("密码已保存到本地: \(fileURL.path)")
        } catch {
            print("保存密码失败: \(error)")
        }
    }
    
    func loadPasswords() -> [PasswordItem] {
        guard let fileURL = passwordsFileURL else {
            print("无法获取密码文件 URL")
            return []
        }
        
        do {
            if !fileManager.fileExists(atPath: fileURL.path) {
                print("密码文件不存在，返回空列表")
                return []
            }
            
            let data = try Data(contentsOf: fileURL)
            let storedItems = try JSONDecoder().decode([StoredPasswordItem].self, from: data)
            
            return try storedItems.map { stored -> PasswordItem in
                let decryptedPassword = try CryptoManager.decrypt(stored.encryptedPassword)
                return PasswordItem(
                    id: stored.id,
                    category: stored.category,
                    note: stored.note,
                    password: decryptedPassword,
                    isPasswordVisible: false
                )
            }
        } catch {
            print("加载密码失败: \(error)")
            return []
        }
    }
    
    func deletePasswords() {
        guard let fileURL = passwordsFileURL else {
            print("无法获取密码文件 URL")
            return
        }
        
        do {
            try fileManager.removeItem(at: fileURL)
            print("密码文件已删除")
        } catch {
            print("删除密码文件失败: \(error)")
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
