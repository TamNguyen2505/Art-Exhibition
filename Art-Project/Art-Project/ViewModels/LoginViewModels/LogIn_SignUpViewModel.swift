//
//  LogIn_SignUpViewModel.swift
//  Art-Project
//
//  Created by Nguyen Minh Tam on 20/08/2022.
//

import UIKit

class LogIn_SignUpViewModel: NSObject {
    //MARK: Properties
    var username: String?
    var fullname: String?
    var email: String?
    var password: String?
    var confirmationPassword: String?
    var avatarImage: UIImage?
    @objc dynamic var logInUserSuccessfully = false
    @objc dynamic var createUserSuccessfully = false
    @objc dynamic var createUserWidthAvatarSuccessfully = false
    private let authenticationViewModel = AuthenticationViewModel()
    
    enum AuthProvider {
        case authEmail
        case authApple
        case authFacebook(presentingViewController: UIViewController)
        case authGoogle(presentingViewController: UIViewController)
        case authZalo
    }
    
    //MARK: Features
    func checkUserName() -> (alert: NSMutableAttributedString?, valid: Bool) {
        guard let userName = email, userName != "" else {return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_lack_of_username_alert)), false)}
        
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
    
    func logInBasedOn(cases: AuthProvider) async throws {
        
        switch cases {
        case .authEmail:
            guard let email = email, let password = password else {return}
            async let success = try await authenticationViewModel.logIn(email: email, password: password)
            
            self.logInUserSuccessfully = try await success
            break
            
        case .authApple:
            break
            
        case .authFacebook(let presentingViewController):
            
            async let success = try await authenticationViewModel.loginWithFacebook(presentingViewController: presentingViewController)
            
            self.logInUserSuccessfully = try await success
            break
            
        case .authGoogle(let presentingViewController):
            
            async let success = try await authenticationViewModel.loginWithGoogle(presentingViewController: presentingViewController)
            
            self.logInUserSuccessfully = try await success
            break
            
        case .authZalo:
            break
        }
        
    }
    
    
}
