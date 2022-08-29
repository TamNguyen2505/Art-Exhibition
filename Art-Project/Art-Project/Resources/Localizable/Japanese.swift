//
//  Japanese.swift
//  Art-Project
//
//  Created by MINERVA on 29/08/2022.
//

import Foundation

struct Japanese: Languages {
    
    static var languageKey: LanguageKey {
        return .japanese
    }

    static func getString(key: LocalizableKey) -> String {
        switch key {
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
        }
        
    }
    
}
