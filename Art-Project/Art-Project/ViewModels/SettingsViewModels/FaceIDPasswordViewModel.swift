//
//  FaceIDPasswordViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 30/08/2022.
//

import UIKit

class FaceIDPasswordViewModel: NSObject {
    //MARK: Properties
    @objc dynamic var didSavePasswordInKeychain = false
    private let userInformationViewModel = UserInformationViewModel.shared
    
    
    //MARK: Features
    func savePasswordInKeychain(password: String?) {
        
        guard let email = userInformationViewModel.fetch()?.first?.email, let password = password, !password.isEmpty else {return}
        let genericQuery = GenericPasswordQuery(accessGroup: .FirebasePassword)
        let keychainManager = KeychainManager(keychainQuery: genericQuery)
        
        do {
            self.didSavePasswordInKeychain = try keychainManager.addPasswordToKeychains(key: email, password: password)
            
        }
        catch {
            
        }
        
    }
    
    private func createRedAlertString(string: String) -> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: string, attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.boldSystemFont(ofSize: 12)])
        
    }
    
    func trailingIconForPasswordTextField(securityOn: Bool) -> UIImage? {
        
        return securityOn ? UIImage(named: "icons8-open-eye") : UIImage(named: "icons8-closed-eye")
        
    }
    
}
