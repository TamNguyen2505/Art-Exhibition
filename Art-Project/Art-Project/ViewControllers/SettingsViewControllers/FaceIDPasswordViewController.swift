//
//  FaceIDPasswordViewController.swift
//  Art-Project
//
//  Created by MINERVA on 25/08/2022.
//

import UIKit

class FaceIDPasswordViewController: BaseViewController {
    //MARK: Properties
    private let securityImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bg_security_by_faceID")
        return iv
    }()
    
    private let passwordTextField: CustomTextView = {
        let tf = CustomTextView()
        tf.setTitle(text: "Password")
        tf.setLeadingIconImage(image: UIImage(named: "icons8-password"))
        tf.setTrailingIconImage(image: UIImage(named: "icons8-open-eye"))
        tf.publicTextField.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var enrollButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(LocalizableManager.getLocalizableString(key: .text_enroll), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleEventFromEnrollButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(LocalizableManager.getLocalizableString(key: .text_cancel), for: .normal)
        btn.setTitleColor(UIColor.systemOrange, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.systemOrange.cgColor
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .white
        return btn
    }()
    
    private let viewModel = FaceIDPasswordViewModel()
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(securityImageView)
        securityImageView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.snp.centerY)
            
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints{ make in
            
            make.top.equalTo(securityImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        let hStackForButton = UIStackView(arrangedSubviews: [enrollButton, cancelButton])
        hStackForButton.axis = .horizontal
        hStackForButton.spacing = 10
        hStackForButton.distribution = .fillEqually
        
        view.addSubview(hStackForButton)
        hStackForButton.snp.makeConstraints{ make in
            
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        enrollButton.snp.makeConstraints{ make in
            
            make.height.equalTo(50)
            make.width.equalTo(cancelButton.snp.width)
            
        }
        
        let switchUIForTrailingButton: ((UITextField, UIButton) -> Void) = { [weak self] (textField, sender) in
            guard let self = self else {return}
            
            textField.isSecureTextEntry.toggle()
            sender.setImage(self.viewModel.trailingIconForPasswordTextField(securityOn: textField.isSecureTextEntry), for: .normal)
            
        }
        
        self.passwordTextField.handleEventFromTrailingButtonToTextField = switchUIForTrailingButton
        
    }
    
    override func setupNavigationStyle() {
        super.setupNavigationStyle()
        
        let leftItem = setupUIForLeftItem(leftItemInfo: .backIcon)
        constraintHeaderStack(accordingTo: .aLeftItem(leftItem: leftItem))
        
    }
    
    override func observeVM() {
        super.observeVM()
        
        let didSavePasswordInKeychain = viewModel.observe(\.didSavePasswordInKeychain, options: [.new]) { [unowned self] vm, receivedValue in
            guard let receivedValue = receivedValue.newValue, receivedValue else {return}
            
            DispatchQueue.main.async {
                
                UserDefaults.isSavedLogin = true
                self.hideTabBarController = false
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
        self.observations.append(didSavePasswordInKeychain)
        
    }
    
    //MARK: Actions
    @objc override func handleEventFromLeftNavigationItem(_ sender: UIButton) {
        super.handleEventFromLeftNavigationItem(sender)
        
        self.hideTabBarController = false
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func handleEventFromEnrollButton(_ sender: UIButton) {
        
        viewModel.savePasswordInKeychain(password: passwordTextField.getString())
        
    }
    
    
}
