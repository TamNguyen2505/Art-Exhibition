//
//  AppDelegate + Extension.swift
//  TableGit
//
//  Created by MINERVA on 01/08/2022.
//

import UIKit

extension AppDelegate {
    
    static func switchToLoginViewController() {
        
        guard let keyWindow = UIApplication.shared.connectedScenes.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] }).first, keyWindow.isKeyWindow else {return}
        
        let rootVC = LoginViewController()
        rootVC.headerType = .noHeader
        let nav = UINavigationController(rootViewController: rootVC)
        
        UIView.transition(with: keyWindow, duration: 0, options: [.transitionCrossDissolve]) {
            
            keyWindow.rootViewController = nav
            
        }

    }
    
    static func switchToArtHomeViewController() {
        
        guard let keyWindow = UIApplication.shared.connectedScenes.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] }).first, keyWindow.isKeyWindow else {return}
        
        let targetVC = BaseTabBarController()
        
        UIView.transition(with: keyWindow, duration: 0, options: [.transitionCrossDissolve]) {
            
            keyWindow.rootViewController = targetVC
            
        }
        
        
    }
    
    
}
