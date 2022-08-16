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
        label.text = "label"
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
        return tf
    }()
    
    private lazy var trailingHelperButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icons8-calendar"), for: .normal)
        return btn
    }()
    
    private let bottomHelperLabel: UILabel = {
        let label = UILabel()
        label.text = "label"
        return label
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}
