//
//  English.swift
//  Art-Project
//
//  Created by MINERVA on 29/08/2022.
//

import Foundation

struct English: Languages {
    
    static var languageKey: LanguageKey {
        return .english
    }
    
    static func getString(key: LocalizableKey) -> String {
        
        return key.rawValue
        
    }
    
}
