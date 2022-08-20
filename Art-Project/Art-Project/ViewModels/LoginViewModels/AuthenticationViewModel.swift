//
//  AuthenticationViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 19/08/2022.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AuthenticationViewModel: NSObject {
    //MARK: Properties
    private let storage = Storage.storage()
    private let Collection_User = Firestore.firestore().collection("users")
    
    //MARK: Fire base
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
 
}
