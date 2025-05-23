import Foundation
import CryptoKit
import Security

class CryptoManager {
    static let shared = CryptoManager()
    private static let keyTag = "com.note.hkc.pwdpass.encryption.key"
    private var cachedKey: SymmetricKey?
    
    private var key: SymmetricKey {
        if let cachedKey = cachedKey {
            return cachedKey
        }
        
        if let existingKey = try? loadKey() {
            cachedKey = existingKey
            return existingKey
        }
        
        let newKey = SymmetricKey(size: .bits256)
        try? saveKey(newKey)
        cachedKey = newKey
        return newKey
    }
    
    // 加密字符串
    static func encrypt(_ string: String) throws -> Data {
        guard let data = string.data(using: .utf8) else {
            throw CryptoError.encodingFailed
        }
        return try shared.encrypt(data)
    }
    
    // 解密为字符串
    static func decrypt(_ data: Data) throws -> String {
        let decryptedData = try shared.decrypt(data)
        guard let string = String(data: decryptedData, encoding: .utf8) else {
            throw CryptoError.decodingFailed
        }
        return string
    }
    
    // 加密数据
    func encrypt(_ data: Data) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        guard let combined = sealedBox.combined else {
            throw CryptoError.encryptionFailed
        }
        return combined
    }
    
    // 解密数据
    func decrypt(_ data: Data) throws -> Data {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
            print("解密失败: \(error)")
            throw CryptoError.decryptionFailed
        }
    }
    
    // MARK: - Private Methods
    
    private func saveKey(_ key: SymmetricKey) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Self.keyTag,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData as String: key.withUnsafeBytes { Data($0) }
        ]
        
        // 先尝试删除已存在的密钥
        SecItemDelete([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Self.keyTag
        ] as CFDictionary)
        
        // 保存新密钥
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("保存密钥失败: \(status)")
            throw CryptoError.keychainError
        }
    }
    
    private func loadKey() throws -> SymmetricKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Self.keyTag,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let keyData = result as? Data else {
            if status == errSecItemNotFound {
                return nil
            }
            print("读取密钥失败: \(status)")
            throw CryptoError.keychainError
        }
        
        return SymmetricKey(data: keyData)
    }
    
    enum CryptoError: Error {
        case encodingFailed
        case decodingFailed
        case encryptionFailed
        case decryptionFailed
        case keychainError
    }
} 