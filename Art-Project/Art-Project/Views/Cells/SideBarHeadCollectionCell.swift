//
//  SideBarHeadCollectionCell.swift
//  Art-Project
//
//  Created by MINERVA on 30/08/2022.
//

import UIKit

class SideBarHeadCollectionCell: UICollectionViewCell {
    //MARK: Properies
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let arrowImage = UIImage(named: "next")
    
    private lazy var arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = arrowImage?.rotate(radians: .pi/2)
        return iv
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
        
        let hStack = UIStackView(arrangedSubviews: [titleLabel, arrowImageView])
        hStack.axis = .horizontal
        hStack.spacing = 10
        
        addSubview(hStack)
        hStack.snp.makeConstraints{ make in
            
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
            
        }
        
        arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        arrowImageView.snp.makeConstraints{ make in
            
            make.width.height.equalTo(14)
            
        }
        
    }
    
    func setupContent(title: String?) {
        
        self.titleLabel.text = title
        
    }
    
    func rotateImage(arrowDown: Bool) {
        
        if arrowDown {
            self.arrowImageView.image = self.arrowImage?.rotate(radians: .pi/2)
        
        }else {
            self.arrowImageView.image = self.arrowImage
            
        }
        
    }
    
}
