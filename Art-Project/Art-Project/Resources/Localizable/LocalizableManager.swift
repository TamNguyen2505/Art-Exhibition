//
//  LocalizableManager.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 14/08/2022.
//

import Foundation

public struct LocalizableManager {
    //MARK: Properties
    static let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"
    static let LCLDefaultLanguage = English.languageKey.rawValue
    static let LCLBaseBundle = "Base"
    static let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"
    
    //MARK: Features
    static func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    static func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    static func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    static func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    static func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    static func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
    
    static func getLocalizableString(key: LocalizableKey) -> String {
                
        if currentLanguage() == English.languageKey.rawValue {
            
            return English.getString(key: key)
            
        } else if currentLanguage() == Japanese.languageKey.rawValue {
            
            return Japanese.getString(key: key)
             
        } else {
            
            return ""
            
        }
        
        
    }
    
}
