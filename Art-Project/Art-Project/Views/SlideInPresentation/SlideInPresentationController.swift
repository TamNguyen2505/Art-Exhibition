//
//  SlideInPresentationController.swift
//  TableGit
//
//  Created by MINERVA on 29/07/2022.
//

import UIKit

class SlideInPresentationController: UIPresentationController {
    //MARK: Properties
    private var direction: PresentationDirection = .left
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventFromBlurView(_:)))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    //MARK: Init
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, direction: PresentationDirection) {
        
        self.direction = direction
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let coordinator = presentedViewController.transitionCoordinator else {return}
        
        containerView.insertSubview(blurEffectView, at: 0)
        blurEffectView.frame = containerView.bounds
        
        coordinator.animate { [weak self] _ in
            guard let self = self else {return}
            
            self.blurEffectView.alpha = 0.4
            
        }
        
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {return}
        
        coordinator.animate { [weak self] _ in
            guard let self = self else {return}

            self.blurEffectView.alpha = 0.0
            
        }
        
    }
    
    override func containerViewWillLayoutSubviews() {
        
        presentedView?.frame = frameOfPresentedViewInContainerView
        
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        switch direction {
        case .left, .right:
            return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
            
        case .bottom, .top:
            return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
        }
        
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        
        switch direction {
        case .right:
            frame.origin.x = containerView!.frame.width*(1.0/3.0)
            
        case .bottom:
            frame.origin.y = containerView!.frame.height*(1.0/3.0)
            
        default:
            frame.origin = .zero
        }
        
        return frame
        
    }
    
    //MARK: Actions
    @objc private func handleEventFromBlurView(_ sender: UITapGestureRecognizer) {
        
        presentingViewController.dismiss(animated: true, completion: nil)
        
    }
    
}
