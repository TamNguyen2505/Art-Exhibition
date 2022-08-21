//
//  LoginViewController.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit

class LoginViewController: BaseViewController {
    //MARK: Properties
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "login-background")
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
        return iv
    }()
    
    private let emailTextField: CustomTextView = {
        let tf = CustomTextView()
        tf.setTitle(text: "Login")
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
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("LOG IN", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleEventFromLogInButton(_:)), for: .touchUpInside)
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
    
    private lazy var faceIdButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icons8-face-id"), for: .normal)
        btn.setTitle("Log in by FaceID", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.1597932875, green: 0.253477037, blue: 0.4077349007, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tintColor = #colorLiteral(red: 0.1597932875, green: 0.253477037, blue: 0.4077349007, alpha: 1)
        btn.addTarget(self, action: #selector(handleEventFromFaceIdButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var authGoogleAction: UICommand = {
        let authGoogle = UICommand(title: LocalizableManager.getLocalizableString(key: .text_login_by_google), image: UIImage(named: "icons8-google"), action: #selector(handleEventFromGoogleLogin))
        
        return authGoogle
    }()
    
    private lazy var authFacebookAction: UICommand = {
        let authFacebook = UICommand(title: LocalizableManager.getLocalizableString(key: .text_login_by_facebook), image: UIImage(named: "icons8-facebook"), action: #selector(handleEventFromFacebookLogin(_:)))
 
        return authFacebook
    }()
    
    private lazy var authAppleAction: UICommand = {
        let authApple = UICommand(title: LocalizableManager.getLocalizableString(key: .text_login_by_apple), image: UIImage(named: "icons8-apple-logo"), action: #selector(handleEventFromAppleLogin(_:)))
        
        return authApple
    }()
    
    private lazy var authZaloAction: UICommand = {
        let authZalo = UICommand(title: LocalizableManager.getLocalizableString(key: .text_login_by_zalo), image: UIImage(named: "icons8-zalo"), action: #selector(handleEventFromZaloLogin(_:)))
        
        return authZalo
    }()
    
    private lazy var authMenu: UIMenu = {
        let menu = UIMenu(title: LocalizableManager.getLocalizableString(key: .text_login), options: UIMenu.Options.displayInline, children: [authGoogleAction, authFacebookAction, authAppleAction, authZaloAction])
        return menu
    }()
    
    private lazy var otherAuthLoginButton: UIButton = {
        let btn = UIButton()
        btn.menu = authMenu
        btn.showsMenuAsPrimaryAction = true
        btn.setImage(UIImage(named: "icons8-log-in"), for: .normal)
        btn.setTitle("Log in by other forms", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.1597932875, green: 0.253477037, blue: 0.4077349007, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tintColor = #colorLiteral(red: 0.1597932875, green: 0.253477037, blue: 0.4077349007, alpha: 1)
        return btn
    }()
    
    private let faceID = BiometricIDAuth.shared
    private var isRightHost = false {
        didSet{
            retrievePassword()
        }
    }

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
        
        let vStackForTextField = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        vStackForTextField.axis = .vertical
        vStackForTextField.spacing = 10
        
        view.addSubview(vStackForTextField)
        vStackForTextField.snp.makeConstraints{ make in
            
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        let hStackForButton = UIStackView(arrangedSubviews: [loginButton, signupButton])
        hStackForButton.axis = .horizontal
        hStackForButton.spacing = 10
        hStackForButton.distribution = .fillEqually
        
        view.addSubview(hStackForButton)
        hStackForButton.snp.makeConstraints{ make in
            
            make.top.equalTo(vStackForTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        loginButton.snp.makeConstraints{ make in
            
            make.height.equalTo(50)
            make.width.equalTo(signupButton.snp.width)
            
        }
        
        view.addSubview(faceIdButton)
        faceIdButton.snp.makeConstraints{ make in
            
            make.top.equalTo(hStackForButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            
        }
        
        view.addSubview(otherAuthLoginButton)
        otherAuthLoginButton.snp.makeConstraints{ make in
            
            make.top.equalTo(faceIdButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            
        }
        
        let switchUIForTrailingButton: ((UITextField, UIButton) -> Void) = { [weak self] (textField, sender) in
            guard let self = self else {return}
            
            textField.isSecureTextEntry.toggle()
            sender.setImage(self.viewModel.trailingIconForPasswordTextField(securityOn: textField.isSecureTextEntry), for: .normal)
            
        }
        
        self.passwordTextField.handleEventFromTrailingButtonToTextField = switchUIForTrailingButton
        
    }
    
    override func observeVM() {
        super.observeVM()
        
        let logInUSerSuccessfully = viewModel.observe(\.logInUserSuccessfully, options: [.new]) { _, receivedValue in
            guard let valid = receivedValue.newValue, valid else {return}
            
            DispatchQueue.main.async {
                
                if valid {
                    
                    AppDelegate.switchToArtHomeViewController()
                    
                } else {
                    
                    Loader.shared.hide()
                    
                }
                
            }
            
        }
        self.observations.append(logInUSerSuccessfully)
        
    }
    
    //MARK: Actions
    @objc func handleEventFromLogInButton(_ sender: UIButton) {
                
        if networkMonitor.status == .satisfied {
            
            viewModel.email = emailTextField.getString()
            let (alertFromUserName, userNameIsValid) = viewModel.checkUserName()
            emailTextField.setAttributedStringForBottomLabel(text: alertFromUserName)
            guard userNameIsValid else {return}
            
            viewModel.password = passwordTextField.getString()
            let (alertFromPassword, passwordIsValid) = viewModel.checkPassword()
            passwordTextField.setAttributedStringForBottomLabel(text: alertFromPassword)
            guard passwordIsValid else {return}
            
            Loader.shared.show()
            
            Task {
                try await viewModel.logInBasedOn(cases: .authEmail)
            }
            
        } else {
            
            showAlertView()
            
        }
                
    }
    
    
    @objc func handleEventFromSignUpButton(_ sender: UIButton) {
        
        let targetVC = SignUpViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
    @objc func handleEventFromFaceIdButton(_ sender: UIButton) {
        
        Task {
            
            self.isRightHost = await faceID.evaluate().success
            
        }
        
    }
    
    @objc func handleEventFromGoogleLogin(_ sender: UICommand) {
        
        Task {
            try await viewModel.logInBasedOn(cases: .authGoogle(presentingViewController: self))
        }
        
    }
    
    @objc func handleEventFromFacebookLogin(_ sender: UICommand) {
        
    }
    
    @objc func handleEventFromAppleLogin(_ sender: UICommand) {
        
    }
    
    @objc func handleEventFromZaloLogin(_ sender: UICommand) {
        
    }
    
    //MARK: Helpers
    private func showAlertView() {
        
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
    
    private func retrievePassword() {

        guard isRightHost else {return}
        
        let genericQuery = GenericPasswordQuery()
        let keychainManager = KeychainManager(keychainQuery: genericQuery)
        
        do{
            let password = try keychainManager.findPasswordInKeychains(key: .JWT)
            passwordTextField.setText(string: password)
        }
        catch {
            
        }
        
    }
    
}
