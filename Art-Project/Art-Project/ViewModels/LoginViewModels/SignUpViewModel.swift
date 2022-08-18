//
//  SignUpViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 18/08/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
      
class SignUpViewModel: NSObject {
    //MARK: Properties
    var userName: String?
    var password: String?
    var confirmationPassword: String?
    @objc dynamic var createUserSuccessfully = false
    
    //MARK: Features
    func checkUserName() -> (alert: NSMutableAttributedString?, valid: Bool) {
        guard let userName = userName, userName != "" else {return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_lack_of_username_alert)), false)}

        return (nil, true)
        
    }
    
    func checkPassword() -> (alert: NSMutableAttributedString?, valid: Bool) {
        guard let password = password, password != "" else {return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_lack_of_password_alert)), false)}
        
        return (nil, true)

    }
    
    func checkConfirmationPassword() -> (alert: NSMutableAttributedString?, valid: Bool) {
        
        guard let confirmationPassword = confirmationPassword, confirmationPassword != "" else {return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_lack_of_password_confirmation_alert)), false)}

        if confirmationPassword != password {
            
            return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_differences_between_passwords)), false)
            
        } else {
            
            return (nil, true)
            
        }
        
    }
    
    func createNewUserName() {
        
        guard let userName = userName, userName != "", let password = password, password != "", checkConfirmationPassword().valid else {return}
        
        Auth.auth().createUser(withEmail: userName, password: password) { [weak self] authResult, error in
            guard let self = self, error == nil else {return}
            
            self.createUserSuccessfully = true
            
        }
        
    }
    
    private func createRedAlertString(string: String) -> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: string, attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.boldSystemFont(ofSize: 12)])
        
    }
    
    func trailingIconForPasswordTextField(securityOn: Bool) -> UIImage? {
        
        return securityOn ? UIImage(named: "icons8-open-eye") : UIImage(named: "icons8-closed-eye")
        
    }
    
}
