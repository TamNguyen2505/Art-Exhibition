//
//  AuthenticationViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 19/08/2022.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AuthenticationViewModel: NSObject {
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
    private let storage = Storage.storage()
    private let Collection_User = Firestore.firestore().collection("users")

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
    
    func createNewUserName() async throws {
        
        guard let email = email, email != "", let password = password, password != "", checkConfirmationPassword().valid else {return}
        
        let userID: String = try await withCheckedThrowingContinuation{ Continuation in
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                switch (authResult, error) {
                case (nil, let error?):
                    Continuation.resume(throwing: error)
                    
                case (let authResult?, nil):
                    Continuation.resume(returning: authResult.user.uid)
                    
                case (nil, nil):
                    Continuation.resume(throwing: "Address encoding failed" as! Error)
                    
                case let (authResult?, error?):
                    Continuation.resume(returning: authResult.user.uid)
                    print(error)
                }
                
            }
            
        }
        
        var data: [String: Any] = ["email": email, "fullname": fullname ?? "", "username": username ?? "", "uid": userID]
                
        let imageURL: String? = try await withCheckedThrowingContinuation{ [weak self] Continuation in
            guard let self = self, let imageData = self.avatarImage?.jpegData(compressionQuality: 0.75) else {
                
                if !userID.isEmpty {
                                        
                    Collection_User.document(userID).setData(data)
                    self?.createUserSuccessfully = true

                } else {
                    self?.createUserSuccessfully = false
                    
                }
                return
            }
            let fileName = userID
            let ref = Storage.storage().reference(withPath: "avatars/\(fileName)")
            
            ref.putData(imageData, metadata: nil) { (metadata, error) in
                switch (metadata, error) {
                case (nil, let error?):
                    Continuation.resume(throwing: error)
                    
                case ( _ , nil):
                    
                    ref.downloadURL { (url, erro) in
                        switch (url, error) {
                        case (nil, let error?):
                            Continuation.resume(throwing: error)
                            
                        case (let url?, nil):
                            Continuation.resume(returning: url.absoluteString)
                            
                        case (nil, nil):
                            Continuation.resume(throwing: "Address encoding failed" as! Error)
                            
                        case let (_?, error?):
                            Continuation.resume(returning: url?.absoluteString)
                            print(error)
                        }
                        
                    }
                    
                case let (_?, error?):
                    Continuation.resume(returning: nil)
                    print(error)
               
                }
                
            }
            
        }
        
        guard let imageURL = imageURL else {return}
        
        data.updateValue(imageURL, forKey: "profileImageURL")
        try await Collection_User.document(userID).setData(data)
        self.createUserWidthAvatarSuccessfully = true
        
    }
    
    func logIn() {
        
        guard let userName = email, userName != "", let password = password, password != "" else {return}
        
        Auth.auth().signIn(withEmail: userName, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            self.logInUserSuccessfully = true
            
        }
        
    }
    
    private func createRedAlertString(string: String) -> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: string, attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.boldSystemFont(ofSize: 12)])
        
    }
    
    func trailingIconForPasswordTextField(securityOn: Bool) -> UIImage? {
        
        return securityOn ? UIImage(named: "icons8-open-eye") : UIImage(named: "icons8-closed-eye")
        
    }
    
    
}
