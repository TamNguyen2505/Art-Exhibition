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
        return btn
    }()
    
    private lazy var faceIDSiwtch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(handleEventFromFaceIDSwitch(_:)), for: .valueChanged)
        return sw
    }()
    
    private let faceIDLabel = UILabel()
    
    private lazy var japanesehSiwtch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = LocalizableManager.currentLanguage() != LocalizableManager.defaultLanguage()
        sw.addTarget(self, action: #selector(handleEventFromJapaneseSwitch(_:)), for: .valueChanged)
        return sw
    }()
    
    private let languagesLabel = UILabel()
    
    private lazy var darkModeSiwtch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(handleEventFromDarkmodeSwitch(_:)), for: .valueChanged)
        return sw
    }()
    
    private let darkModeLabel = UILabel()
    
    private let textFontLabel = UILabel()
    
    private let viewModel = SettingsViewModel()
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        Loader.shared.show()
        
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
        
        let faceIDView = createSingleButton(nameOfImageButton: "icons8-face-id", label: faceIDLabel, optionalButton: faceIDSiwtch)
        let japaneseView = createSingleButton(nameOfImageButton: "icons8-language", label: languagesLabel, optionalButton: japanesehSiwtch)
        let themeView = createSingleButton(nameOfImageButton: "icons8-light-automation", label: darkModeLabel, optionalButton: darkModeSiwtch)
        let fontSizeView = createSingleButton(nameOfImageButton: "icons8-text-width", label: textFontLabel)
        
        let vStavk = UIStackView(arrangedSubviews: [faceIDView, japaneseView, themeView, fontSizeView])
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
        
        observeLanguagesChange()
        translateLanguagesInSettingsVC()
        
    }
    
    override func setupNavigationStyle() {
        super.setupNavigationStyle()
        
        let leftItem = setupUIForLeftItem(leftItemInfo: .hamburgerIcon)
        constraintHeaderStack(accordingTo: .aLeftItem(leftItem: leftItem))
        
    }
    
    override func observeVM() {
        super.observeVM()
        
        let observationDidGetUserInformation = viewModel.observe(\.didGetUserInformation, options: [.new]) { [weak self] _ , _ in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                
                self.avatarImageView.image = self.viewModel.avtarImage
                
            }
            
        }
        self.observations.append(observationDidGetUserInformation)
        
        let observationDidValidRightFace = viewModel.observe(\.didValidRightFace, options: [.new]) { [weak self] _, receivedValue in
            guard let self = self, let value = receivedValue.newValue, value else {return}
            
            DispatchQueue.main.async {
                
                let targetVC = FaceIDPasswordViewController()
                
                self.hideTabBarController = true
                self.navigationController?.pushViewController(targetVC, animated: true)
                
            }
            
            
        }
        self.observations.append(observationDidValidRightFace)
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        Task {
            
            try await viewModel.getUserInformation()
            Loader.shared.hide()
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(LocalizableManager.LCLLanguageChangeNotification), object: nil)
    }
    
    //MARK: Actions
    override func handleEventFromLeftNavigationItem(_ sender: UIButton) {
        super.handleEventFromLeftNavigationItem(sender)
        
        self.openSideBar()
        
    }
    
    @objc func handleEventFromFaceIDSwitch(_ sender: UISwitch) {
        
        viewModel.validateFaceID(switchOn: sender.isOn)
        
    }
    
    @objc func handleEventFromJapaneseSwitch(_ sender: UISwitch) {
        
        viewModel.changeLanguages(switchOn: sender.isOn)
        
    }
    
    @objc func handleEventFromDarkmodeSwitch(_ sender: UISwitch) {
        
                
    }
    
    //MARK: Helpers
    private func createSingleButton(nameOfImageButton: String, label: UILabel, optionalButton: UIControl? = nil) -> UIView {
        
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
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                
        let hStackHolder: UIStackView
        
        if let optionalButton = optionalButton {
            
            let hStack = UIStackView(arrangedSubviews: [buttonImageView, label, optionalButton])
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
            
            let hStack = UIStackView(arrangedSubviews: [buttonImageView, label, arrowImageView])
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
    
    
}

//MARK: Languages changes
extension SettingsViewController {
    private func observeLanguagesChange() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.translateLanguagesInSettingsVC), name: Notification.Name(LocalizableManager.LCLLanguageChangeNotification), object: nil)
        
    }
    
    @objc private func translateLanguagesInSettingsVC() {
        
        self.faceIDLabel.text = LocalizableManager.getLocalizableString(key: .text_faceID)
        self.darkModeLabel.text = LocalizableManager.getLocalizableString(key: .text_dark_mode)
        self.textFontLabel.text = LocalizableManager.getLocalizableString(key: .text_font_size)
        self.languagesLabel.text = LocalizableManager.getLocalizableString(key: .text_languages)
                
    }
    
}
