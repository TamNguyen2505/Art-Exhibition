//
//  AppDelegate.swift
//  Art-Project
//
//  Created by MINERVA on 16/08/2022.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FacebookCore
import ZaloSDK

//@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        ZaloSDK.sharedInstance().initialize(withAppId: "2921235391973454953")
        return true
        
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
        var share: Bool
        
        if #available(* , iOS 11) {
            
            share = ApplicationDelegate.shared.application(
                application,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
            
        }
        
        share = ZDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            options: options[UIApplication.OpenURLOptionsKey.annotation] as? [UIApplication.OpenURLOptionsKey : Any])
        
        share = GIDSignIn.sharedInstance.handle(url)
        
        return share
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

