//
//  SignUpViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 30/08/2022.
//

import UIKit

class SignUpViewModel: NSObject {
    //MARK: Properties
    var username: String?
    var fullname: String?
    var email: String?
    var password: String?
    var confirmationPassword: String?
    var avatarImage: UIImage?
    @objc dynamic var createUserSuccessfully = false
    @objc dynamic var createUserWidthAvatarSuccessfully = false
    private let authenticationViewModel = AuthenticationViewModel.shared
    
    //MARK: Features
    func checkUserName() -> (alert: NSMutableAttributedString?, valid: Bool) {
        guard let userName = email, !userName.isEmpty else {return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_lack_of_username_alert)), false)}
        
        return (nil, true)
        
    }
    
    func checkPassword() -> (alert: NSMutableAttributedString?, valid: Bool) {
        guard let password = password, !password.isEmpty else {return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_lack_of_password_alert)), false)}
        
        return (nil, true)
        
    }
    
    func checkPasswordIsRightFormat() -> (alert: NSMutableAttributedString?, valid: Bool) {
        
        guard let password = password, !password.isEmpty else {return (nil,false)}
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~])[A-Za-z\\d !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~]{12,}"

        let result = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        
        if !result {
            
            return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_wrong_format_password)), false)
            
        } else {
            
            return (nil, true)
            
        }

        
    }
    
    func checkConfirmationPassword() -> (alert: NSMutableAttributedString?, valid: Bool) {
        
        guard let confirmationPassword = confirmationPassword, !confirmationPassword.isEmpty else {return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_lack_of_password_confirmation_alert)), false)}
        
        if confirmationPassword != password {
            
            return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_differences_between_passwords)), false)
            
        } else {
            
            return (nil, true)
            
        }
        
    }
    
    private func createRedAlertString(string: String) -> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: string, attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.boldSystemFont(ofSize: 12)])
        
    }
    
    func trailingIconForPasswordTextField(securityOn: Bool) -> UIImage? {
        
        return securityOn ? UIImage(named: "icons8-open-eye") : UIImage(named: "icons8-closed-eye")
        
    }
    
    func createNewAccountByEmail() async {
        guard let email = email, let password = password else {return}
        
        do {
            async let success = try await authenticationViewModel.createNewUserNameInFireBase(email: email, password: password, fullName: fullname, userName: username, profileImage: avatarImage)
            self.createUserSuccessfully = try await success
            
        }
        catch {
            
        }
        
    }
    
}
