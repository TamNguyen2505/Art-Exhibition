//
//  CustomTextView.swift
//  TableGit
//
//  Created by MINERVA on 15/08/2022.
//

import UIKit

class CustomTextView: UIView {
    //MARK: Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let leadingIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icons8-calendar")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.backgroundColor = .white
        return tf
    }()
    
    private lazy var trailingHelperButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.isHidden = true
        btn.addTarget(self, action: #selector(handleEventFromTrailingHelperButton), for: .touchUpInside)
        return btn
    }()
    
    private let bottomHelperLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var publicTextField: UITextField {
        return self.textField
    }
    
    var handleEventFromTrailingButtonToTextField: ((_ textfield: UITextField,_ sender: UIButton) -> Void)?
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func handleEventFromTrailingHelperButton(_ sender: UIButton) {
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            
            self.handleEventFromTrailingButtonToTextField?(self.textField, sender)
            
        }
        
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        let hStackView = UIStackView(arrangedSubviews: [leadingIconImageView, textField, trailingHelperButton])
        hStackView.axis = .horizontal
        hStackView.spacing = 5
        
        leadingIconImageView.snp.makeConstraints{ make in
            
            make.width.height.equalTo(43)
            
        }
        
        trailingHelperButton.snp.makeConstraints{ make in
            
            make.width.height.equalTo(43)
            
        }
        
        let vStackView = UIStackView(arrangedSubviews: [hStackView, bottomHelperLabel])
        vStackView.axis = .vertical
        vStackView.spacing = 5
        
        addSubview(vStackView)
        vStackView.snp.makeConstraints{ make in
            
            make.edges.equalToSuperview()
            
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            
            make.centerY.equalTo(textField.snp.top)
            make.leading.equalTo(textField.snp.leading).offset(5)
            make.trailing.greaterThanOrEqualTo(textField.snp.trailing)
            
        }
        
    }
    
    //MARK: Features to set
    func setText(string: String?) {
        
        self.textField.text = string
        
    }
    
    func setTitle(text: String, placeHolder: String? = nil) {
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [.backgroundColor: UIColor.white])
        titleLabel.attributedText = attributedString
        
        guard let placeHolder = placeHolder else {return}
        textField.attributedPlaceholder = NSMutableAttributedString(string: placeHolder, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        
    }
    
    func setLeadingIconImage(image: UIImage?) {
        
        self.leadingIconImageView.image = image
        
    }
    
    func setTrailingIconImage(image: UIImage?) {
        
        self.trailingHelperButton.isHidden = false
        self.trailingHelperButton.setImage(image, for: .normal)
        
    }
    
    func setAttributedStringForBottomLabel(text: NSMutableAttributedString?) {
        guard let text = text else {return}
        
        self.bottomHelperLabel.attributedText = text
        
    }
    
    //MARK: Features to get
    func getString() -> String? {
        
        return self.textField.text
        
    }
    
    func getHashedString() -> String? {
        
        return self.textField.text?.challenge()
        
    }
    
}
