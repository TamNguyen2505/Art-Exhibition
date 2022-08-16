//
//  SignUpViewController.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit

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
        return btn
    }()
    
    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
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
        btn.addTarget(self, action: #selector(handleEventFromSignUpButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    
    //MARK: Actions
    @objc func handleEventFromSignUpButton(_ sender: UIButton) {
        
        
        
    }
    
    @objc func handleEventFromCancelButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    //MARK: Helpers
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
        
        let vStackForTextField = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField])
        vStackForTextField.axis = .vertical
        vStackForTextField.spacing = 10
        vStackForTextField.distribution = .fillEqually
        
        view.addSubview(vStackForTextField)
        vStackForTextField.snp.makeConstraints{ make in
            
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        usernameTextField.snp.makeConstraints{ make in
            
            make.height.equalTo(50)
            
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
        
    }
    

}
