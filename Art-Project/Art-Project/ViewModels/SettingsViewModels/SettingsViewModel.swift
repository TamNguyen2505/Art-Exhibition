//
//  SettingsViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 16/08/2022.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import GoogleSignIn
import FBSDKCoreKit

class SettingsViewModel: NSObject {
    //MARK: Properties
    private let faceID = BiometricIDAuth.shared
    private let networkManager = NetworkManager()
    private let Collection_User = Firestore.firestore().collection("users")
    @objc dynamic var didGetUserInformation = false
    @objc dynamic var didValidRightFace = false
    private var userInformation: UserModel? = nil
    var avtarImage: UIImage? = nil
    private var isRightHost = false {
        didSet{
            saveKeychain()
        }
    }
    
    
    //MARK: Features
    func getUserInformation() async throws {
        
        guard let currentUser = Auth.auth().currentUser else {return}
        
        for provider in currentUser.providerData {
            switch provider.providerID {
            case GoogleAuthProviderID:
                guard let googleUser = GIDSignIn.sharedInstance.currentUser else {return}
                let user = UserModel(googleUser: googleUser)
                
                async let image = getImageFromUserInformation(urlString: user.profileImageURL)
                self.avtarImage = await image
                
                self.didGetUserInformation = true
                break
                
            default:
                let user: UserModel = try await withCheckedThrowingContinuation{ Continuation in
                    
                    Collection_User.document(currentUser.uid).getDocument{ (snapshot, error) in
                        switch (snapshot, error) {
                        case (nil, let error?):
                            Continuation.resume(throwing: error)
                            
                        case (let snapshot?, nil):
                            guard let dictionary = snapshot.data() else {return}
                            let user = UserModel(dictionary: dictionary)
                            
                            Continuation.resume(returning: user)
                            
                        case (nil, nil):
                            Continuation.resume(throwing: "Address encoding failed" as! Error)
                            
                        case let (_?, error?):
                            print(error)
                            break
                        }
                        
                    }
                    
                }
                
                async let image = getImageFromUserInformation(urlString: user.profileImageURL)
                self.avtarImage = await image
                
                self.didGetUserInformation = true
                break
            }
            
        }
        
        
    }
    
    func getImageFromUserInformation(urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString)?.absoluteString else {
            
            self.didGetUserInformation = true
            return nil
            
        }
        
        do {
            
            guard let data = try await networkManager.downloadData(accordingTo: .downloadPortraitImage(baseURL: url)) else {return nil}
            return UIImage(data: data)
            
        } catch {
            
            return nil
            
        }
        
    }
    
    func validateFaceID(switchOn: Bool) {
        
        guard switchOn else {return}
        
        Task {
            
            async let isRightHost = await faceID.evaluate().success
            self.didValidRightFace = await isRightHost
            
        }
        
    }
    
    private func saveKeychain() {
        
        guard isRightHost else {return}
        
        let genericQuery = GenericPasswordQuery(service: KeychainKey.FirebasePassword.rawValue)
        let keychainManager = KeychainManager(keychainQuery: genericQuery)
        
        do{
            
            try keychainManager.addPasswordToKeychains(key: .JWT, password: "tamnm1996")
            
        }
        
        catch {
            
        }
        
    }
    
    func changeLanguages(switchOn: Bool) {
        
        if switchOn {
            
            LocalizableManager.setCurrentLanguage(Japanese.languageKey.rawValue)
            
        } else {
            
            LocalizableManager.resetCurrentLanguageToDefault()
            
        }
        
    }
    
    
}
