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
    case text_lack_of_username_alert = "Please enter your username!"
    case text_lack_of_password_alert = "Please enter your password!"
    case text_lack_of_password_confirmation_alert = "Please confirm your password!"
    case text_differences_between_passwords = "Please correct your confirmation password!"
    case text_wrong_username = "Please check your username!"
    case text_wrong_passowrd = "Please check your password!"
    
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
            
        case .text_lack_of_username_alert:
            return "ユーザー名を入力してください!"
            
        case .text_lack_of_password_alert:
            return "パスワードを入力してください"
            
        case .text_lack_of_password_confirmation_alert:
            return "パスワードを確認してください。!"
            
        case .text_differences_between_passwords:
            return "確認パスワードを修正してください。!"
            
        case .text_wrong_username:
            return "ユーザー名を確認してください。!"
            
        case .text_wrong_passowrd:
            return "パスワードを確認してください。!"
        }
        
    }
    
}
