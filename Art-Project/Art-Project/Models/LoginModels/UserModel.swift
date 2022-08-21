//
//  UserModel.swift
//  Art-Project
//
//  Created by MINERVA on 19/08/2022.
//

import Foundation
import GoogleSignIn

struct UserModel {
    //MARK: Properties
    public private(set) var email: String
    public private(set) var fullName: String
    public private(set) var userName: String
    public private(set) var profileImageURL: String
    public private(set) var uid: String
    
    //MARK: Init
    init(dictionary: [String: Any]) {
        
        self.email = dictionary["email"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.userName = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
    }
    
    init(googleUser: GIDGoogleUser) {
        
        self.email = googleUser.profile?.email ?? ""
        self.fullName = googleUser.profile?.name ?? ""
        self.profileImageURL = googleUser.profile?.imageURL(withDimension: 120)?.absoluteString ?? ""
        self.userName = googleUser.profile?.givenName ?? ""
        self.uid = googleUser.userID ?? ""
        
    }
    
    
}
