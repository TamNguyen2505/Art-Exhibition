//
//  UserDefaults + Extension.swift
//  TableGit
//
//  Created by MINERVA on 29/07/2022.
//

import Foundation

extension UserDefaults {
    
    enum Keys: String, CaseIterable {
        
        case isSavedLogin = "savedLogin"
        case userName = "userName"
        
    }
    
    static var userName: String {
        
        get {
            return UserDefaults.standard.string(forKey: Keys.userName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.userName.rawValue)
        }
        
    }
    
    static var isSavedLogin: Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: Keys.isSavedLogin.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.isSavedLogin.rawValue)
        }
        
    }
    
    
}
