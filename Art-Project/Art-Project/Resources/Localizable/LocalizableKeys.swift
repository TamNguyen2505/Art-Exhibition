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
    case text_faceID = "Face ID"
    case text_languages = "Languages"
    case text_dark_mode = "Dark mode"
    case text_font_size = "Font size"
    
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
            
        case .text_faceID:
            return "顔認証"
            
        case .text_languages:
            return "言語"
            
        case .text_dark_mode:
            return "ダークモード"
            
        case .text_font_size:
            return "フォントサイズ"
            
        }
        
    }
    
}
