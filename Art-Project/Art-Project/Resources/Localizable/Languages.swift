//
//  Languages.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 14/08/2022.
//

import Foundation

protocol Languages {
    
    var english: String {get}
    var japanese: String {get}
    
}

struct LanguagesKeys {
    //MARK: Properties
    static let share = LanguagesKeys()
    
}

//MARK: Languages confirmation
extension LanguagesKeys: Languages {
    
    var english: String {
        return "en"
    }
    
    var japanese: String {
        return "ja"
    }
    
}
