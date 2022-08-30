//
//  NewsTableCell.swift
//  TableGit
//
//  Created by MINERVA on 03/08/2022.
//

import UIKit

class NewsTableCell: UITableViewCell {
    //MARK: Properties
    private let objectImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "signup-background")
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleObjectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Object"
        return label
    }()
    
    private let dateObjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "20/03/2021"
        label.textColor = .lightGray
        return label
    }()
    
    private let widthObjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "123"
        label.textColor = .lightGray
        return label
    }()
    
    private let heightObjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "124"
        label.textColor = .lightGray
        return label
    }()
    
    private let greyLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.6, alpha: 0.4)
        return view
    }()
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        selectionStyle = .none
                
        objectImageView.snp.makeConstraints{ make in
            
            make.width.height.equalTo(80)
            
        }
        
        let containerView = UIView()
        
        containerView.addSubview(titleObjectLabel)
        titleObjectLabel.snp.makeConstraints{ make in
            
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            
        }
        
        let widthImage = UIImage(named: "icons8-width")
        let widthView = createSingleStackView(includes: widthImage, label: widthObjectLabel)
        
        containerView.addSubview(widthView)
        widthView.snp.makeConstraints{ make in
            
            make.top.equalTo(titleObjectLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleObjectLabel.snp.leading)
            
        }
        
        let dateImage = UIImage(named: "icons8-calendar")
        let dateView = createSingleStackView(includes: dateImage, label: dateObjectLabel)
        
        containerView.addSubview(dateView)
        dateView.snp.makeConstraints{ make in
            
            make.top.equalTo(widthView.snp.top)
            make.trailing.equalTo(titleObjectLabel.snp.trailing)
            make.leading.greaterThanOrEqualTo(widthView.snp.trailing)
            
        }

        let heightImage = widthImage?.rotate(radians: -.pi/2)
        let heightView = createSingleStackView(includes: heightImage, label: heightObjectLabel)
        
        containerView.addSubview(heightView)
        heightView.snp.makeConstraints{ make in
            
            make.top.equalTo(widthView.snp.bottom).offset(10)
            make.leading.equalTo(titleObjectLabel.snp.leading)
            make.trailing.greaterThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
            
        }
                
        let hStackView = UIStackView(arrangedSubviews: [objectImageView, containerView])
        hStackView.axis = .horizontal
        hStackView.spacing = 10
        hStackView.alignment = .top
        
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints{ make in
            
            make.top.equalToSuperview().inset(20)
            make.trailing.leading.equalToSuperview().inset(16)
            
        }
        
        contentView.addSubview(greyLineView)
        greyLineView.snp.makeConstraints{ make in
            
            make.top.equalTo(hStackView.snp.bottom).offset(20)
            make.leading.equalTo(hStackView.snp.leading)
            make.trailing.equalTo(hStackView.snp.trailing)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            
        }
                
    }
    
    private func createSandwitchView(middleView: UIView) -> UIStackView {
        
        let aboveView = UIView()
        let underView = UIView()
        
        let vStack = UIStackView(arrangedSubviews: [aboveView, middleView, underView])
        vStack.axis = .vertical
        
        aboveView.snp.makeConstraints{ make in
            
            make.height.equalTo(underView.snp.height)
            
        }
        
        return vStack
        
    }
    
    private func createSingleStackView(includes image: UIImage?, label: UILabel) -> UIView {
        
        let containerView = UIView()
                
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .center
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            
            make.top.leading.equalToSuperview()
            
        }
        
        containerView.addSubview(label)
        label.snp.makeConstraints{ make in
            
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.centerY.equalTo(imageView.snp.centerY)
            make.bottom.trailing.equalToSuperview()
            
        }
        
        return containerView
        
    }
    
    func updateContent(viewModel: NewsTableCellViewModel) {
        
        self.titleObjectLabel.text = viewModel.titleImage
        self.widthObjectLabel.text = viewModel.widthValue
        self.heightObjectLabel.text = viewModel.heightValue
        self.dateObjectLabel.text = viewModel.dateValue
 
    }
    
    func setupImage(image: UIImage?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            
            self.objectImageView.image = image
            
        }
                
    }
    
}
