//
//  CustomTransitioningStyle.swift
//  TableGit
//
//  Created by MINERVA on 29/07/2022.
//

import UIKit

enum PresentationDirection {
    
    case left
    case top
    case right
    case bottom
    
}

class SlideInPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    //MARK: Properties
    var direction: PresentationDirection = .left
    var disableCompactHeight = false
    
    //MARK: Protocol confirmation
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = SlideInPresentationController(presentedViewController: presented, presentingViewController: presenting, direction: direction)
        
        return presentationController
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SlideInPresentationAnimator(direction: direction, isPresentation: true)
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SlideInPresentationAnimator(direction: direction, isPresentation: false)
        
    }
    
}

// MARK: UIAdaptivePresentationControllerDelegate
extension SlideInPresentationManager: UIAdaptivePresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
            
            return .overFullScreen
            
        } else {
            
            return .none
            
        }
        
    }
    
}

