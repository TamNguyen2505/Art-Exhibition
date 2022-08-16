//
//  LocalizableKeys.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 14/08/2022.
//

import Foundation

public enum LocalizableKey: String {
    
    case text_home = "Home"
    case text_news = "News"
    case text_audio = "Audios"
    case text_graph = "Graphs"
    case text_settings = "Settings"
    
}

extension LocalizableKey: Languages {
    
    var english: String {
        switch self {
        default:
            return rawValue
        }
    }
    
    var japanese: String {
        switch self {
        case .text_home:
            return "家"
            
        case .text_news:
            return "ニュース"
            
        case .text_audio:
            return "オーディオ"
            
        case .text_graph:
            return "グラフ"
            
        case .text_settings:
            return "設定"
            
        }
        
    }
    
}
