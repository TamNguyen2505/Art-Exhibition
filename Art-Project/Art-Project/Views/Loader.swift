//
//  Loader.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 25/06/2022.
//
import UIKit

public final class Loader {
    //MARK: Properties
    public static let shared = Loader()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.4
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventFromBlurView(_:)))
        view.addGestureRecognizer(tap)
        
        return view
    }()

    
    private let activeIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView()
        av.color = UIColor.systemGreen
        av.backgroundColor = UIColor.white
        av.style = .large
        av.startAnimating()
        return av
    }()
    
    //MARK: Actions
    @objc private func handleEventFromBlurView(_ sender: UITapGestureRecognizer) {
        
        hide()
        
    }
    
    //MARK: Helper
    private func setupUIForActiveIndicator() {
        
        blurEffectView.contentView.addSubview(activeIndicator)
        activeIndicator.snp.makeConstraints{ make in

            make.center.equalToSuperview()
            make.width.height.equalTo(50)

        }
        
        activeIndicator.layer.cornerRadius = 25
        
    }

    //MARK: Methods
    func show() {
        
        guard let keyWindow = UIApplication.shared.connectedScenes.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] }).first, keyWindow.isKeyWindow else {return}
        
        keyWindow.addSubview(blurEffectView)
        blurEffectView.frame = keyWindow.frame
        
        setupUIForActiveIndicator()
        
        
    }

    func hide() {
        
        blurEffectView.removeFromSuperview()
        activeIndicator.removeFromSuperview()

    }
    
    func showInView(view: UIView) {
        
        view.addSubview(blurEffectView)
        blurEffectView.frame = view.frame
        
        setupUIForActiveIndicator()

    }
    
}
