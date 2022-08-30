//
//  LogInViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 30/08/2022.
//

import Foundation
import AuthenticationServices

class LogInViewModel: NSObject {
    //MARK: Properties
    var email: String?
    var password: String?
    @objc dynamic var logInUserSuccessfully = false
    private let authenticationViewModel = AuthenticationViewModel()
    
    enum AuthProvider {
        case authEmail
        case authApple(presentingViewController: UIViewController & ASAuthorizationControllerPresentationContextProviding)
        case authFacebook(presentingViewController: UIViewController)
        case authGoogle(presentingViewController: UIViewController)
        case authZalo(presentingViewController: UIViewController)
    }
    
    //MARK: Features
    func checkUserName() -> (alert: NSMutableAttributedString?, valid: Bool) {
        guard let userName = email, !userName.isEmpty else {return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_lack_of_username_alert)), false)}
        
        return (nil, true)
        
    }
    
    func checkPassword() -> (alert: NSMutableAttributedString?, valid: Bool) {
        guard let password = password, !password.isEmpty else {return (createRedAlertString(string: LocalizableManager.getLocalizableString(key: .text_lack_of_password_alert)), false)}
        
        return (nil, true)
        
    }
    
    private func createRedAlertString(string: String) -> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: string, attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.boldSystemFont(ofSize: 12)])
        
    }
    
    func trailingIconForPasswordTextField(securityOn: Bool) -> UIImage? {
        
        return securityOn ? UIImage(named: "icons8-open-eye") : UIImage(named: "icons8-closed-eye")
        
    }
    
    func logInBasedOn(cases: AuthProvider) async throws {
        
        switch cases {
        case .authEmail:
            guard let email = email, let password = password else {return}
            async let success = try await authenticationViewModel.logIn(email: email, password: password)
            
            self.logInUserSuccessfully = try await success
            break
            
        case .authApple (let presentingViewController):
            async let success = try await authenticationViewModel.loginWithApple(presentingController: presentingViewController)
            
            self.logInUserSuccessfully = try await success
            break
            
        case .authFacebook(let presentingViewController):
            async let success = try await authenticationViewModel.loginWithFacebook(presentingViewController: presentingViewController)
            
            self.logInUserSuccessfully = try await success
            break
            
        case .authGoogle(let presentingViewController):
            async let success = try await authenticationViewModel.loginWithGoogle(presentingViewController: presentingViewController)
            
            self.logInUserSuccessfully = try await success
            break
            
        case .authZalo(let presentingViewController):
            authenticationViewModel.loginWithZalo(presentingViewController: presentingViewController) { [weak self] success in
                guard let self = self else {return}
                
                self.logInUserSuccessfully = success
                
            }
            
            break
        }
        
    }
    
    
}
