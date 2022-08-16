//
//  KeychainManager.swift
//  TableGit
//
//  Created by MINERVA on 28/07/2022.
//

import Foundation

enum KeychainKey: String {
    
    case JWT = "user-jwt"
    case SoftOTPPin = "soft-otp-pin"
    case TokenSeed = "token-seed"
    
}

struct KeychainManager {
    //MARK: Properties
    private let keychainQuery: KeychainQuery
    
    //MARK: Init
    init(keychainQuery: KeychainQuery) {
        
        self.keychainQuery = keychainQuery
        
    }
    
    //MARK: Features
    func addPasswordToKeychains(key: KeychainKey, password: String) throws {
        guard let encodedPassword = password.data(using: .utf8) else {throw KeychainError.stringToDataConversionError}
        
        var basicQuery = keychainQuery.query
        basicQuery.updateValue(key.rawValue, forKey: kSecAttrAccount as String)
        
        var status = SecItemCopyMatching(basicQuery as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            let attributesToUpdate: [String: Any] = [kSecValueData as String: encodedPassword]
            
            status = SecItemUpdate(basicQuery as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == errSecSuccess else { throw error(from: status) }
            break
            
        case errSecItemNotFound:
            basicQuery.updateValue(encodedPassword, forKey: kSecValueData as String)
            
            status = SecItemAdd(basicQuery as CFDictionary, nil)
            
            guard status == errSecSuccess else {throw error(from: status) }
            break

        default:
            throw error(from: status)
            
        }
        
    }
    
    func findPasswordInKeychains(key: KeychainKey) throws -> String? {
        
        var basicQuery = keychainQuery.query
        
        basicQuery.updateValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        basicQuery.updateValue(true, forKey: kSecReturnAttributes as String)
        basicQuery.updateValue(true, forKey: kSecReturnData as String)
        basicQuery.updateValue(key.rawValue, forKey: kSecAttrAccount as String)
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(basicQuery as CFDictionary, &item)
        
        switch status {
        case errSecSuccess:
            guard let existingItem = item as? [String : Any],
                let passwordData = existingItem[kSecValueData as String] as? Data,
                let password = String(data: passwordData, encoding: String.Encoding.utf8)
                    
            else {
                
                throw KeychainError.dataToStringConversionError
            }
            
            return password
            
        case errSecItemNotFound:
            return nil
            
        default:
            throw error(from: status)
            
        }
    
    }
    
    func deleteKeychain(key: KeychainKey) throws {
        
        let basicQuery = keychainQuery.query

        let status = SecItemDelete(basicQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw error(from: status)}
                
    }
    
    public func removeAllValues() throws {
        
      let basicQuery = keychainQuery.query

      let status = SecItemDelete(basicQuery as CFDictionary)
      guard status == errSecSuccess || status == errSecItemNotFound else {
        throw error(from: status)
      }
        
    }
    
    //MARK: Helpers
    private func error(from status: OSStatus) -> KeychainError {
        
      let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
      return KeychainError.unhandledError(status: message)
        
    }
    
}
