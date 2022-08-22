//
//  AppleAuthenticationViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 22/08/2022.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

class AppleAuthenticationViewModel: NSObject, ASAuthorizationControllerDelegate {
    //MARK: Properties
    typealias AuthCredentialContinuation = CheckedContinuation<AuthCredential, Error>
    private var continuation: AuthCredentialContinuation?
    private var currentNonce: String?
    
    //MARK: Init
    init(continuation: AuthCredentialContinuation, currentNonce: String, authorizationController: ASAuthorizationController) {
        self.continuation = continuation
        self.currentNonce = currentNonce
        super.init()
        
        authorizationController.delegate = self
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                continuation?.resume(throwing: "Invalid state: A login callback was received, but no login request was sent." as! Error)
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                continuation?.resume(throwing: "Unable to fetch identity token" as! Error)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                continuation?.resume(throwing: "Unable to serialize token string from data: \(appleIDToken.debugDescription)" as! Error)
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            continuation?.resume(returning: credential)
            
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        continuation?.resume(throwing: error)
        
    }
    
}
