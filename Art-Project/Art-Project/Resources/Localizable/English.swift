//
//  English.swift
//  Art-Project
//
//  Created by MINERVA on 29/08/2022.
//

import Foundation

struct English: Languages {

    static func getKeyLanguage(key: LanguageKey) -> String {
        
        return key.rawValue
        
    }
    
    static func getString(key: LocalizableKey) -> String {
        
        return key.rawValue
        
    }
    
}
