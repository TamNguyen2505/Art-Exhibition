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
    case text_login_by_google = "Log In by Google"
    case text_login_by_facebook = "Log In by Facebook"
    case text_login_by_apple = "Log In by Apple"
    case text_login_by_zalo = "Log In by Zalo"
    case text_login = "Log In"
    case text_wrong_format_password = "Pasword must contain at least 1 Uppercase, 1 Lowercase, 1 Special Characters, 1 Number, and Total 12 Characters! Please check it again!"
    case text_enroll = "ENROLL"
    case text_cancel = "CANCEL"
    case text_enroll_faceID_login = "FaceID Login Enroll"

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
            
        case .text_login_by_google:
            return "Google でログイン"
            
        case .text_login_by_facebook:
            return "Facebook でログイン"
            
        case .text_login_by_apple:
            return "Apple でログイン"
            
        case .text_login_by_zalo:
            return "Zalo でログイン"
            
        case .text_login:
            return "でログイン"
            
        case .text_wrong_format_password:
            return "パスワードには、少なくとも 1 つの大文字、1 つの小文字、1 つの特殊文字、1 つの数字、および合計 12 文字を含める必要があります。もう一度チェックしてください！"
            
        case .text_enroll:
            return "登録"
            
        case .text_cancel:
            return "キャンセル"
            
        case .text_enroll_faceID_login:
            return "FaceID ログイン 登録"
        }
        
    }
    
}
