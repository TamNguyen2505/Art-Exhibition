//
//  DetailedNewsViewController.swift
//  TableGit
//
//  Created by MINERVA on 03/08/2022.
//

import UIKit
import Combine

class DetailedNewsViewController: BaseViewController {
    //MARK: Properties
    private lazy var largestImageView: UIImageView = {
        let iv = setupUIForImageViews()
        return iv
    }()
    
    private lazy var topRightImageView: UIImageView = {
        let iv = setupUIForImageViews()
        return iv
    }()
    
    private lazy var bottomRightImageView: UIImageView = {
        let iv = setupUIForImageViews()
        return iv
    }()
    
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressViewStyle = .bar
        return view
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let colorPalletTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Color Pallet"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var colorPalletCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 100, height: 200)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(ColorPalletCollectionCell.self, forCellWithReuseIdentifier: ColorPalletCollectionCell.className)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    var objectID: String = ""
    
    private let viewModel = DetailedNewsViewModel()
    
    private var dataImage = UIImage() {
        
        didSet{
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                
                self.largestImageView.image = self.dataImage.rotate(radians: .pi/2)
                
            }
            
        }
        
    }
    
    var cancellable: AnyCancellable?
    
    private var percent: Float = 0.0 {
        willSet{
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}

                self.progressView.progress = self.percent
                self.progressLabel.text = self.viewModel.createPercentString(value: self.percent)
                
            }

        }
    }
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        let hStackOfGroupOfImages = setupUIForGroupOfImageViews()
        
        view.addSubview(hStackOfGroupOfImages)
        hStackOfGroupOfImages.snp.makeConstraints{ make in
            
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            
        }
         
        let progressView = setupUIForProgressView()
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints{ make in
            
            make.top.equalTo(hStackOfGroupOfImages.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        view.addSubview(colorPalletTitleLabel)
        colorPalletTitleLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.greaterThanOrEqualToSuperview()
            
        }
        
        view.addSubview(colorPalletCollection)
        colorPalletCollection.snp.makeConstraints{ make in
            
            make.top.equalTo(colorPalletTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
            
        }
        
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        Task {
            
            await viewModel.getDetailedInformationOfObject(objectID: self.objectID)
            
        }
    
    }
    
    //MARK: Helpers
    private func setupUIForGroupOfImageViews() -> UIStackView {
        
        let vStack = UIStackView(arrangedSubviews: [topRightImageView, bottomRightImageView])
        vStack.spacing = 10
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        
        topRightImageView.snp.makeConstraints{ make in
            
            make.height.equalTo(150)
            
        }
        
        let hStack = UIStackView(arrangedSubviews: [largestImageView, vStack])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.distribution = .fillEqually
        
        largestImageView.snp.makeConstraints{ make in
            
            make.width.equalTo(vStack.snp.width)
            
        }
        
        return hStack
        
    }
    
    private func setupUIForProgressView() -> UIView {
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 5.0
        
        containerView.addSubview(progressView)
        progressView.snp.makeConstraints{ make in
            
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            
        }
        
        containerView.addSubview(progressLabel)
        progressLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.leading.equalTo(progressView.snp.leading)
            make.trailing.greaterThanOrEqualToSuperview()
            make.bottom.equalToSuperview().inset(10)
            
        }
        
        return containerView
        
    }
    
    private func setupUIForImageViews() -> UIImageView {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "signup-background")
        iv.layer.borderColor = UIColor.systemYellow.cgColor
        iv.layer.borderWidth = 3
        iv.layer.cornerRadius = 5
        
        return iv
        
    }
    
    
}

//MARK: Collection view data source
extension DetailedNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorPalletCollectionCell.className, for: indexPath) as! ColorPalletCollectionCell
        
        
        return cell
        
    }
    
}

extension DetailedNewsViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Task {
            
            cancellable = viewModel.$percent.assign(to: \.percent, on: self)
            
            guard let id = self.viewModel.detailedInformationOfObject.images?.first?.iiifbaseuri else {return}
                        
            let image = try await viewModel.streamDownloadImage(imageID: id)
            self.dataImage = image ?? UIImage()
            
            cancellable?.cancel()
                        
        }
        
    }
    
  
}
