//
//  SettingsViewController.swift
//  TableGit
//
//  Created by MINERVA on 22/07/2022.
//

import UIKit

class SettingsViewController: BaseViewController {
    //MARK: Properties
    private let scrollView: UIScrollView = {
        let width = UIScreen.main.bounds.width
        let height = CGFloat.greatestFiniteMagnitude
        
        let view = UIScrollView()
        view.contentSize = CGSize(width: width, height: height)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
    
    private lazy var faceIDSiwtch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(handleEventFromFaceIDSwitch(_:)), for: .valueChanged)
        return sw
    }()
    
    private lazy var englishSiwtch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    private lazy var darkModeSiwtch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(handleEventFromDarkmodeSwitch(_:)), for: .valueChanged)
        return sw
    }()
    
    private let faceID = BiometricIDAuth.shared
    private var isRightHost = false {
        didSet{
            saveKeychain()
        }
    }
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        headerType = .headerWidthRightSlideMenu
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints{ make in
            
            make.edges.width.equalToSuperview()
            
        }
        
        contentView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 120 / 2
        avatarImageView.snp.makeConstraints{ make in
            
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            
        }
        
        contentView.addSubview(uploadImageButton)
        uploadImageButton.snp.makeConstraints{ make in
            
            make.width.height.equalTo(45)
            make.top.equalTo(avatarImageView.snp.top)
            make.trailing.equalToSuperview().inset(20)
            
        }
        
        let faceIDView = createSingleButton(nameOfImageButton: "icons8-face-id", nameOfButton: "Face ID", optionalButton: faceIDSiwtch)
        let englishView = createSingleButton(nameOfImageButton: "icons8-language", nameOfButton: "Languages", optionalButton: englishSiwtch)
        let themeView = createSingleButton(nameOfImageButton: "icons8-light-automation", nameOfButton: "Theme", optionalButton: darkModeSiwtch)
        let fontSizeView = createSingleButton(nameOfImageButton: "icons8-text-width", nameOfButton: "Font size")
        
        let vStavk = UIStackView(arrangedSubviews: [faceIDView, englishView, themeView, fontSizeView])
        vStavk.axis = .vertical
        vStavk.spacing = 10
        vStavk.distribution = .fillEqually
        
        contentView.addSubview(vStavk)
        vStavk.snp.makeConstraints{ make in
            
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            
        }
        
        faceIDView.snp.makeConstraints{ make in
            
            make.height.equalTo(50)
            
        }
        
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        
    }
    
    //MARK: Actions
    @objc func handleEventFromFaceIDSwitch(_ sender: UISwitch) {
        
        guard sender.isOn else {return}
        
        Task {
            
            self.isRightHost = await faceID.evaluate().success
            
        }
        
    }
    
    @objc func handleEventFromDarkmodeSwitch(_ sender: UISwitch) {
        
                
    }
    
    //MARK: Helpers
    private func createSingleButton(nameOfImageButton: String, nameOfButton: String, optionalButton: UIControl? = nil) -> UIView {
        
        let outView = UIView()
        outView.backgroundColor = .white
        outView.layer.cornerRadius = 5.0
        outView.layer.borderWidth = 1.0
        outView.layer.borderColor = UIColor.init(white: 0.5, alpha: 0.6).cgColor
        outView.layer.shadowColor = UIColor.init(white: 0.6, alpha: 0.4).cgColor
        outView.layer.shadowOffset = .init(width: 3, height: 3)
        outView.layer.shadowRadius = 4.0
        outView.layer.shadowOpacity = 1.0
        
        let buttonImageView = UIImageView()
        buttonImageView.image = UIImage(named: nameOfImageButton)
        buttonImageView.contentMode = .center
        buttonImageView.setContentHuggingPriority(.required, for: .horizontal)
        
        let buttonNameTitle = UILabel()
        buttonNameTitle.font = UIFont.systemFont(ofSize: 14)
        buttonNameTitle.text = nameOfButton
        buttonNameTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                
        let hStackHolder: UIStackView
        
        if let optionalButton = optionalButton {
            
            let hStack = UIStackView(arrangedSubviews: [buttonImageView, buttonNameTitle, optionalButton])
            hStack.axis = .horizontal
            hStack.spacing = 10
            hStack.alignment = .center
            hStackHolder = hStack
            
            optionalButton.setContentHuggingPriority(.required, for: .horizontal)
                    
        } else {
            
            let arrowImageView = UIImageView()
            arrowImageView.image = UIImage(named: "next")
            arrowImageView.contentMode = .center
            arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
            
            let hStack = UIStackView(arrangedSubviews: [buttonImageView, buttonNameTitle, arrowImageView])
            hStack.axis = .horizontal
            hStack.spacing = 10
            hStack.alignment = .center
            hStackHolder = hStack
            
        }
        
        outView.addSubview(hStackHolder)
        hStackHolder.snp.makeConstraints { make in
            
            make.bottom.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            
        }
        
        return outView
        
    }
    
    //MARK: Helpers
    private func saveKeychain() {
        
        guard isRightHost else {return}
        
        let genericQuery = GenericPasswordQuery()
        let keychainManager = KeychainManager(keychainQuery: genericQuery)
        
        do{
            
            try keychainManager.addPasswordToKeychains(key: .JWT, password: "tamnm1996")
            
        }
        
        catch {
            
        }
        
    }
    
    
}
