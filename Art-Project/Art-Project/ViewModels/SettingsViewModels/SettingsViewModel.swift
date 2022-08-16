//
//  SettingsViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 16/08/2022.
//

import Foundation

class SettingsViewModel {
    //MARK: Properties
    private let faceID = BiometricIDAuth.shared
    private var isRightHost = false {
        didSet{
            saveKeychain()
        }
    }
    
    
    //MARK: Features
    func validateFaceID(switchOn: Bool) {
        
        guard switchOn else {return}
        
        Task {
            
            self.isRightHost = await faceID.evaluate().success
            
        }
        
    }
    
    private func saveKeychain() {
        
        guard isRightHost else {return}
        
        let genericQuery = GenericPasswordQuery()
        let keychainManager = KeychainManager(keychainQuery: genericQuery)
        
        do{
            
            try keychainManager.addPasswordToKeychains(key: .JWT, password: "tamnm1996")
            
        }
        
        catch {
            
        }
        
    }
    
    func changeLanguages(switchOn: Bool) {
        
        if switchOn {
            
            LocalizableManager.setCurrentLanguage(LanguagesKeys.share.japanese)
            
        } else {
            
            LocalizableManager.resetCurrentLanguageToDefault()
            
        }
                
    }
    
    
}
