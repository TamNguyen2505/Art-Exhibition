//
//  SideBarCollectionCell.swift
//  Art-Project
//
//  Created by MINERVA on 29/08/2022.
//

import UIKit

class SideBarCollectionCell: UICollectionViewListCell {
    //MARK: Properties
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "signup-background")?.resize(targetSize: .init(width: 50, height: 50))
        iv.clipsToBounds = true
        return iv
    }()
    
    private let iconTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //MARK: View cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        let hStack = UIStackView(arrangedSubviews: [iconImageView, iconTitleLabel])
        hStack.spacing = 10
        hStack.axis = .horizontal
        
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints{ make in
            
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(5)
            
        }
        
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        
    }
    
    func setupContent(data: SideBarSectionModel) {
        
        self.iconImageView.image = data.itemImage?.resize(targetSize: .init(width: 50, height: 50))
        self.iconTitleLabel.text = data.title
        
    }
    
}
