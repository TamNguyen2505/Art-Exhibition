//
//  Languages.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 14/08/2022.
//

import Foundation

public protocol Languages {
    
    static func getKeyLanguage(key: LanguageKey) -> String
    static func getString(key: LocalizableKey) -> String
    
}


