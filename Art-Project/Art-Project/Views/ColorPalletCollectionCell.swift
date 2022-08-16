//
//  ColorPalletCollectionCell.swift
//  TableGit
//
//  Created by MINERVA on 03/08/2022.
//

import UIKit

class ColorPalletCollectionCell: UICollectionViewCell {
    //MARK: Properties
    private let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    private let colorValueTitle: UILabel = {
        let label = UILabel()
        label.text = "#255425"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
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
        
        contentView.addSubview(colorView)
        colorView.snp.makeConstraints{ make in
            
            make.top.trailing.leading.equalToSuperview().inset(5)
            
        }
        
        contentView.addSubview(colorValueTitle)
        colorValueTitle.snp.makeConstraints{ make in
            
            make.top.equalTo(colorView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
            
        }
        
        
    }
    
    
}
