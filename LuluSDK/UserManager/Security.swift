import Foundation
import Security

class SecureStorageManager {
    
    static let shared = SecureStorageManager()
    
    private init() {}
    
    // Keychain Access: Save Data
    func saveToKeychain(key: String, value: String) {
        let data = value.data(using: .utf8)!
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        
        // Delete any existing item for the key before adding a new one
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Data saved successfully")
        } else {
            print("Error saving data to Keychain: \(status)")
        }
    }
    
    // Keychain Access: Retrieve Data
    func retrieveFromKeychain(key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            print("Error retrieving data from Keychain: \(status)")
            return nil
        }
    }
    
    // Keychain Access: Delete Data
    func deleteFromKeychain(key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Data deleted successfully from Keychain")
        } else {
            print("Error deleting data from Keychain: \(status)")
        }
    }
}

