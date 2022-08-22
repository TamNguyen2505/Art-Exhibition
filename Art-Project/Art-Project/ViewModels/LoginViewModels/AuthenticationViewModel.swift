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
import GoogleSignIn
import FacebookLogin
import AuthenticationServices
import CryptoKit

class AuthenticationViewModel: NSObject {
    //MARK: Properties
    private let storage = Storage.storage()
    private let Collection_User = Firestore.firestore().collection("users")
    
    //MARK: Email
    func createNewUserNameInFireBase(email: String, password: String, fullName: String? = nil, userName: String? = nil, profileImage: UIImage? = nil) async throws -> Bool {
        
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
        
        var data: [String: Any] = ["email": email, "fullname": fullName ?? "", "username": userName ?? "", "uid": userID]
        
        guard let imageData = profileImage?.jpegData(compressionQuality: 0.75) else {
            
            if !userID.isEmpty {
                try await Collection_User.document(userID).setData(data)
                return true
                
            } else {
                return false
                
            }
            
        }
        
        let imageURL: String = try await withCheckedThrowingContinuation{ Continuation in
            
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
                            Continuation.resume(throwing: error)
                        }
                        
                    }
                    
                case let (_?, error?):
                    Continuation.resume(throwing: error)
                    
                }
                
            }
            
        }
        
        data.updateValue(imageURL, forKey: "profileImageURL")
        try await Collection_User.document(userID).setData(data)
        return true
        
    }
    
    func logIn(email: String, password: String) async throws -> Bool {
        
        let sucess: Bool = try await withCheckedThrowingContinuation { Continuation in
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                switch (authResult, error) {
                case (nil, let error?):
                    Continuation.resume(throwing: error)
                    
                case ( _?, nil):
                    Continuation.resume(returning: true)
                    
                case (nil, nil):
                    Continuation.resume(throwing: "Address encoding failed" as! Error)
                    
                case let (_?, error?):
                    Continuation.resume(throwing: error)
                    
                }
                
            }
            
        }
        
        return sucess
        
    }
    
    func logOut() {
        
        do {
            try Auth.auth().signOut()
            AppDelegate.switchToLoginViewController()
            
        }
        
        catch {
            return
            
        }
        
    }
    
    private func firebaseLogin(_ credential: AuthCredential) async throws -> Bool {
        
        if let user = Auth.auth().currentUser {
            
            let succes: Bool = try await withCheckedThrowingContinuation{ Continuation in
                
                user.link(with: credential) { authResult, error in
                    switch (authResult, error) {
                    case (nil, let error?):
                        Continuation.resume(throwing: error)
                        
                    case ( _?, nil):
                        Continuation.resume(returning: true)
                        
                    case (nil, nil):
                        Continuation.resume(throwing: "Address encoding failed" as! Error)
                        
                    case let (_?, error?):
                        Continuation.resume(throwing: error)
                        
                    }
                    
                }
                
            }
            
            return succes
            
        } else {
            
            let succes: Bool = try await withCheckedThrowingContinuation{ Continuation in
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    switch (authResult, error) {
                    case (nil, let error?):
                        Continuation.resume(throwing: error)
                        
                    case ( _?, nil):
                        Continuation.resume(returning: true)
                        
                    case (nil, nil):
                        Continuation.resume(throwing: "Address encoding failed" as! Error)
                        
                    case let (_?, error?):
                        Continuation.resume(throwing: error)
                        
                    }
                    
                }
                
            }
            
            return succes
            
        }
        
    }
    
    //MARK: Google
    @MainActor func loginWithGoogle(presentingViewController: UIViewController) async throws -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {return false}
        let config = GIDConfiguration(clientID: clientID)
        
        let authCredential: AuthCredential = try await withCheckedThrowingContinuation { Continuation in
            
            GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingViewController) { user, error in
                switch (user, error) {
                case (nil, let error?):
                    Continuation.resume(throwing: error)
                    
                case (let user, nil):
                    guard let authentication = user?.authentication,
                          let idToken = authentication.idToken else {return}
                    
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                    
                    Continuation.resume(returning: credential)
                    
                case let (_?, error?):
                    Continuation.resume(throwing: error)
                    
                }
                
            }
            
        }
        
        return try await firebaseLogin(authCredential)
        
    }
    
    //MARK: Facebook
    @MainActor func loginWithFacebook(presentingViewController: UIViewController) async throws -> Bool {
        let loginManager = LoginManager()
        
        let authCredential: AuthCredential = try await withCheckedThrowingContinuation { Continuation in
            
            loginManager.logIn(permissions: ["email"], from: presentingViewController) { user, error in
                switch (user, error) {
                case (nil, let error?):
                    Continuation.resume(throwing: error)
                    
                case (_, nil):
                    guard let idToken = AccessToken.current?.tokenString else {return}
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: idToken)
                    
                    Continuation.resume(returning: credential)
                    
                case let (_?, error?):
                    Continuation.resume(throwing: error)
                    
                }
                
            }
            
            
        }
        
        return try await firebaseLogin(authCredential)
        
    }
    
    //MARK: Apple
    typealias AuthCredentialContinuation = CheckedContinuation<AuthCredential, Error>
    fileprivate var delegateContinuation: AppleAuthenticationViewModel?
    
    @MainActor func loginWithApple<T: UIViewController & ASAuthorizationControllerPresentationContextProviding>(presentingController: T) async throws -> Bool {
        let nonce = randomNonceString()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = presentingController
        authorizationController.performRequests()
        
        let authCredential: AuthCredential = try await withCheckedThrowingContinuation{ [weak self] Continuation in
            guard let self = self else {return}
            
            self.delegateContinuation = AppleAuthenticationViewModel(continuation: Continuation, currentNonce: nonce, authorizationController: authorizationController)
            
        }
        
        return try await firebaseLogin(authCredential)
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
}

