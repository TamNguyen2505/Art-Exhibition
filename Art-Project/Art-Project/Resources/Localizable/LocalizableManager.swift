//
//  LocalizableManager.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 14/08/2022.
//

import Foundation

open class LocalizableManager: NSObject {
    //MARK: Properties
    static let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"
    static let LCLDefaultLanguage = LanguagesKeys.share.english
    static let LCLBaseBundle = "Base"
    static let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"
    
    //MARK: Features
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    open class func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    open class func defaultLanguage() -> String {
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
    
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
    
    open class func getLocalizableString(key: LocalizableKey) -> String {
        
        if currentLanguage() == LanguagesKeys.share.english {
            
            return key.english
            
        } else if currentLanguage() == LanguagesKeys.share.japanese {
            
            return key.japanese
             
        } else {
            
            return ""
            
        }
        
        
    }
    
}
