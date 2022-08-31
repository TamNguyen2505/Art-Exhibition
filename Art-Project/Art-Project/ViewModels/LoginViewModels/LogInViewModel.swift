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
    var password: String? {
        didSet {
            logInIfRightFace()
        }
    }
    var avatarImage: UIImage?
    @objc dynamic var logInUserSuccessfully = false
    private let userInformationViewModel = UserInformationViewModel.shared
    private let faceID = BiometricIDAuth.shared
    private let authenticationViewModel = AuthenticationViewModel.shared
    private var didValidRightFace = false {
        didSet {
            getPasswordInKeychain()
        }
    }
    
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
    
    func fetchUserInCoreData() {
        guard let user = userInformationViewModel.fetch()?.first else {return}

        self.email = user.email
        
        guard let data = user.profileImage else {return}
        self.avatarImage = UIImage(data: data)
        
    }
    
    func validateFaceID() {
                
        Task {
            
            async let isRightHost = await faceID.evaluate().success
            self.didValidRightFace = await isRightHost
            
        }
        
    }
    
    private func getPasswordInKeychain() {
        
        guard let email = email, didValidRightFace else {return}
        
        let genericQuery = GenericPasswordQuery(accessGroup: .FirebasePassword)
        let keychainManager = KeychainManager(keychainQuery: genericQuery)
        
        do {
            self.password = try keychainManager.findPasswordInKeychains(key: email)
            
        }
        catch {
            
        }
        
    }
    
    private func logInIfRightFace() {
        
        Task {
            try await logInBasedOn(cases: .authEmail)
        }
        
    }
    
}
