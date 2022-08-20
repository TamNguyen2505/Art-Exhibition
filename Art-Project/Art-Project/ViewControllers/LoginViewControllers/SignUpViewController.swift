//
//  SignUpViewController.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit
import Photos

class SignUpViewController: BaseViewController {
    //MARK: Properties
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "signup-background")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let topGradientCurvedView: TopGradientCurvedView = {
        let view = TopGradientCurvedView()
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "default-avatar")
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var uploadImageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        btn.tintColor = #colorLiteral(red: 0.1597932875, green: 0.253477037, blue: 0.4077349007, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 2
        btn.layer.borderColor = #colorLiteral(red: 0.1597932875, green: 0.253477037, blue: 0.4077349007, alpha: 1).cgColor
        btn.scalesLargeContentImage = true
        btn.addTarget(self, action: #selector(handleEventFromCameraButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    private let userNameTextField: CustomTextView = {
        let tf = CustomTextView()
        tf.setTitle(text: "Username")
        tf.setLeadingIconImage(image: UIImage(named: "icons8-user"))
        return tf
    }()
    
    private let userFullNameTextField: CustomTextView = {
        let tf = CustomTextView()
        tf.setTitle(text: "Full name")
        tf.setLeadingIconImage(image: UIImage(named: "icons8-user"))
        return tf
    }()
    
    private let emailTextField: CustomTextView = {
        let tf = CustomTextView()
        tf.setTitle(text: "Email")
        tf.setLeadingIconImage(image: UIImage(named: "icons8-user"))
        return tf
    }()
    
    private let passwordTextField: CustomTextView = {
        let tf = CustomTextView()
        tf.setTitle(text: "Password")
        tf.setLeadingIconImage(image: UIImage(named: "icons8-password"))
        tf.setTrailingIconImage(image: UIImage(named: "icons8-open-eye"))
        tf.publicTextField.isSecureTextEntry = true
        return tf
    }()
    
    private let confirmPasswordTextField: CustomTextView = {
        let tf = CustomTextView()
        tf.setTitle(text: "Confirmation password")
        tf.setLeadingIconImage(image: UIImage(named: "icons8-password"))
        tf.setTrailingIconImage(image: UIImage(named: "icons8-open-eye"))
        tf.publicTextField.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("CANCEL", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleEventFromCancelButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var signupButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("SIGN UP", for: .normal)
        btn.setTitleColor(UIColor.systemOrange, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.systemOrange.cgColor
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handleEventFromSignUpButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    private let viewModel = LogIn_SignUpViewModel()
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints{ make in
            
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
        view.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 120 / 2
        avatarImageView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            
        }
        
        view.addSubview(topGradientCurvedView)
        topGradientCurvedView.snp.makeConstraints{ make in
            
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(avatarImageView.snp.bottom)
            
        }
        view.bringSubviewToFront(avatarImageView)
        
        view.addSubview(uploadImageButton)
        uploadImageButton.snp.makeConstraints{ make in
            
            make.width.height.equalTo(45)
            make.top.equalTo(avatarImageView.snp.top)
            make.trailing.equalToSuperview().inset(20)
            
        }
        
        let vStackForTextField = UIStackView(arrangedSubviews: [userNameTextField, userFullNameTextField, emailTextField, passwordTextField, confirmPasswordTextField])
        vStackForTextField.axis = .vertical
        vStackForTextField.spacing = 10
        
        view.addSubview(vStackForTextField)
        vStackForTextField.snp.makeConstraints{ make in
            
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        let hStackForButton = UIStackView(arrangedSubviews: [cancelButton, signupButton])
        hStackForButton.axis = .horizontal
        hStackForButton.spacing = 10
        hStackForButton.distribution = .fillEqually
        
        view.addSubview(hStackForButton)
        hStackForButton.snp.makeConstraints{ make in
            
            make.top.equalTo(vStackForTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        cancelButton.snp.makeConstraints{ make in
            
            make.height.equalTo(50)
            make.width.equalTo(signupButton.snp.width)
            
        }
        
        let switchUIForTrailingButton: ((UITextField, UIButton) -> Void) = { [weak self] (textField, sender) in
            guard let self = self else {return}
            
            textField.isSecureTextEntry.toggle()
            sender.setImage(self.viewModel.trailingIconForPasswordTextField(securityOn: textField.isSecureTextEntry), for: .normal)
            
        }
        
        self.passwordTextField.handleEventFromTrailingButtonToTextField = switchUIForTrailingButton
        self.confirmPasswordTextField.handleEventFromTrailingButtonToTextField = switchUIForTrailingButton
        
    }
    
    override func setupNavigationStyle() {
        super.setupNavigationStyle()
        
        let leftItem = setupUIForLeftItem(leftItemInfo: .backIcon)
        constraintHeaderStack(accordingTo: .aLeftItem(leftItem: leftItem))
        
    }
    
    override func observeVM() {
        super.observeVM()
        
        let obserCreateUserSuccessfully = viewModel.observe(\.createUserSuccessfully, options: [.new]) { _, receivedValue in
            guard let valid = receivedValue.newValue, valid else {return}
            
            DispatchQueue.main.async {
                
                if valid {
                    
                    AppDelegate.switchToArtHomeViewController()
                    
                } else {
                    
                    Loader.shared.hide()
                    
                }
                
            }
            
        }
        self.observations.append(obserCreateUserSuccessfully)
        
    }
    
    //MARK: Actions
    override func handleEventFromLeftNavigationItem(_ sender: UIButton) {
        super.handleEventFromLeftNavigationItem(sender)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func handleEventFromCameraButton(_ sender: UIButton) {
        
        showAlertForPickingUpPhoto()
        
    }
    
    @objc func handleEventFromSignUpButton(_ sender: UIButton) {
        
        if networkMonitor.status == .satisfied {
            
            viewModel.username = userNameTextField.getString()
            viewModel.fullname = userFullNameTextField.getString()
            
            viewModel.email = emailTextField.getString()
            let (alertFromUserName, userNameIsValid) = viewModel.checkUserName()
            emailTextField.setAttributedStringForBottomLabel(text: alertFromUserName)
            guard userNameIsValid else {return}
            
            viewModel.password = passwordTextField.getString()
            let (alertFromPassword, passwordIsValid) = viewModel.checkPassword()
            passwordTextField.setAttributedStringForBottomLabel(text: alertFromPassword)
            guard passwordIsValid else {return}
            
            viewModel.confirmationPassword = confirmPasswordTextField.getString()
            let (alertFromConfirmationPassword, confirmationPasswordIsValid) = viewModel.checkConfirmationPassword()
            confirmPasswordTextField.setAttributedStringForBottomLabel(text: alertFromConfirmationPassword)
            guard confirmationPasswordIsValid else {return}
            
            Loader.shared.show()
            
            Task {
                await viewModel.createNewAccountByEmail()
            }
            
        } else {
            
            showAlertViewAfterInternetChecking()
            
        }
        
        
    }
    
    @objc func handleEventFromCancelButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: Helpers
    private func showAlertViewAfterInternetChecking() {
        
        let alert = UIAlertController(title: "Notification", message: "Please check the Internet Access", preferredStyle: .alert)
        
        let open = UIAlertAction(title: "Settings", style: .default) { _ in
            
            guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {return}
            
            if UIApplication.shared.canOpenURL(settingUrl) {
                
                UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
                
            }
            
        }
        alert.addAction(open)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func showAlertForPickingUpPhoto() {
        
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default){ [weak self] (action: UIAlertAction) in
            guard let self = self else {return}
            
            self.getImage(fromSourceType: .camera)
            
        }
        alert.addAction(camera)
        
        let library = UIAlertAction(title: "Photo Library", style: .default){ [weak self] (action: UIAlertAction) in
            guard let self = self else {return}
            
            self.getImage(fromSourceType: .photoLibrary)
            
        }
        alert.addAction(library)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {return}
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            guard let self = self, let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            
            self.viewModel.avatarImage = image
            self.avatarImageView.image = image
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
