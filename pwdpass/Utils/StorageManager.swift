import Foundation
import OSLog

private let logger = Logger(subsystem: "com.note.hkc.pwdpass", category: "Storage")

enum StorageError: LocalizedError {
    case directoryNotFound
    case encryptionFailed
    case decryptionFailed
    case fileWriteFailed(Error)
    case fileReadFailed(Error)

    var errorDescription: String? {
        switch self {
        case .directoryNotFound:
            return "无法访问存储目录"
        case .encryptionFailed:
            return "数据加密失败"
        case .decryptionFailed:
            return "数据解密失败，密钥可能已损坏"
        case .fileWriteFailed(let error):
            return "写入文件失败：\(error.localizedDescription)"
        case .fileReadFailed(let error):
            return "读取文件失败：\(error.localizedDescription)"
        }
    }
}

class StorageManager {
    static let shared = StorageManager()
    private let fileManager = FileManager.default

    private var storageDirectoryURL: URL? {
        guard let appSupport = try? fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ) else {
            logger.error("无法获取 Application Support 目录")
            return nil
        }
        return appSupport.appendingPathComponent("嗅密")
    }

    private var passwordsFileURL: URL? {
        storageDirectoryURL?.appendingPathComponent("passwords.data")
    }

    private var categoriesFileURL: URL? {
        storageDirectoryURL?.appendingPathComponent("categories.json")
    }

    private init() {
        setupStorageDirectory()
    }

    private func setupStorageDirectory() {
        guard let directoryURL = storageDirectoryURL else {
            logger.error("无法创建存储目录：storageDirectoryURL 为 nil")
            return
        }

        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
                logger.info("创建存储目录成功: \(directoryURL.path)")
            } catch {
                logger.error("创建存储目录失败: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Passwords

    /// 保存密码（不抛错，供内部/兼容使用）
    func savePasswords(_ passwords: [PasswordItem]) {
        do {
            try savePasswordsWithError(passwords)
        } catch {
            logger.error("保存密码失败: \(error.localizedDescription)")
        }
    }

    /// 保存密码（抛出详细错误）
    func savePasswordsWithError(_ passwords: [PasswordItem]) throws {
        guard let fileURL = passwordsFileURL else {
            throw StorageError.directoryNotFound
        }

        let encodedItems = try passwords.map { item -> StoredPasswordItem in
            let encryptedPassword = try CryptoManager.encrypt(item.password)
            return StoredPasswordItem(
                id: item.id,
                category: item.category,
                note: item.note,
                encryptedPassword: encryptedPassword
            )
        }

        do {
            let data = try JSONEncoder().encode(encodedItems)
            try data.write(to: fileURL)
        } catch {
            throw StorageError.fileWriteFailed(error)
        }
    }

    /// 加载密码（不抛错，供兼容使用）
    func loadPasswords() -> [PasswordItem] {
        do {
            return try loadPasswordsWithError()
        } catch {
            logger.error("加载密码失败: \(error.localizedDescription)")
            return []
        }
    }

    /// 加载密码（抛出详细错误）
    func loadPasswordsWithError() throws -> [PasswordItem] {
        guard let fileURL = passwordsFileURL else {
            throw StorageError.directoryNotFound
        }

        if !fileManager.fileExists(atPath: fileURL.path) { return [] }

        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            throw StorageError.fileReadFailed(error)
        }

        let storedItems: [StoredPasswordItem]
        do {
            storedItems = try JSONDecoder().decode([StoredPasswordItem].self, from: data)
        } catch {
            throw StorageError.fileReadFailed(error)
        }

        return try storedItems.map { stored -> PasswordItem in
            let decryptedPassword: String
            do {
                decryptedPassword = try CryptoManager.decrypt(stored.encryptedPassword)
            } catch {
                throw StorageError.decryptionFailed
            }
            return PasswordItem(
                id: stored.id,
                category: stored.category,
                note: stored.note,
                password: decryptedPassword,
                isPasswordVisible: false
            )
        }
    }

    func deletePasswords() {
        guard let fileURL = passwordsFileURL else { return }

        do {
            try fileManager.removeItem(at: fileURL)
            logger.info("密码文件已删除")
        } catch {
            logger.error("删除密码文件失败: \(error.localizedDescription)")
        }
    }

    // MARK: - Categories

    func saveCategories(_ categories: [String]) {
        guard let fileURL = categoriesFileURL else { return }

        do {
            let data = try JSONEncoder().encode(categories)
            try data.write(to: fileURL)
        } catch {
            logger.error("保存分类失败: \(error.localizedDescription)")
        }
    }

    func loadCategories() -> [String]? {
        guard let fileURL = categoriesFileURL else { return nil }

        do {
            if !fileManager.fileExists(atPath: fileURL.path) { return nil }
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            logger.error("加载分类失败: \(error.localizedDescription)")
            return nil
        }
    }
}

// 用于存储的密码项模型
private struct StoredPasswordItem: Codable {
    let id: UUID
    let category: String
    let note: String
    let encryptedPassword: Data
}
