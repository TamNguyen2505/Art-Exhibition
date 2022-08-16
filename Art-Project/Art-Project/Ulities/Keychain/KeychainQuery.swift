//
//  KeychainQuery.swift
//  TableGit
//
//  Created by MINERVA on 01/08/2022.
//

import Foundation

public protocol KeychainQuery {
    
    var query: [String: Any] {get}
    
}

public struct GenericPasswordQuery {
    //MARK: Properties
    let service: String
    let accessGroup: String?
    
    //MARK: Init
    init(service: String = Bundle.main.bundleIdentifier ?? "", accessGroup: String? = nil) {
        
      self.service = service
      self.accessGroup = accessGroup
        
    }
    
}

//MARK: SecureQuery confirmation
extension GenericPasswordQuery: KeychainQuery {
    
    public var query: [String : Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service
        
        #if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
            
          query[String(kSecAttrAccessGroup)] = accessGroup
            
        }
        #endif
        
        return query
        
    }
    
}
