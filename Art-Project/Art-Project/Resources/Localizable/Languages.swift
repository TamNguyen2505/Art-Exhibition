//
//  Languages.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 14/08/2022.
//

import Foundation

protocol Languages {
    
    static var languageKey: LanguageKey {get}
    static func getString(key: LocalizableKey) -> String
    
}


