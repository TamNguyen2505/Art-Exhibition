//
//  RecordInformationViewController.swift
//  TableGit
//
//  Created by MINERVA on 10/08/2022.
//

import UIKit

class RecordInformationViewController: BaseViewController {
    //MARK: Properties
    private lazy var recordImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "signup-background")
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var recordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "recordTitle"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    private let artistImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "signup-background")
        iv.contentMode = .center
        iv.layer.cornerRadius = 5
        iv.layer.borderColor = UIColor.systemYellow.cgColor
        iv.layer.borderWidth = 3
        iv.clipsToBounds = true
        return iv
    }()
    
    private let infomationArtistLabel: UILabel = {
        let label = UILabel()
        label.text = "information"
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var recordCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(HomeCollectionView.self, forCellWithReuseIdentifier: HomeCollectionView.className)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = .init(top: 0, left: 20, bottom: 20, right: 20)
        collection.delegate = self
        collection.dataSource = self
        collection.prefetchDataSource = self
        return collection
    }()
    
    var personid: Int?
    var firstRecordTitle: String?
    var firstRecordImage: UIImage?
    
    private let viewModel = RecordInfomationViewModel()
    
    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath: DataLoadOperation]()

    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        Loader.shared.show()
                
        view.addSubview(recordImageView)
        recordImageView.snp.makeConstraints{ make in
            
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(280)
            
        }
        
        recordImageView.addSubview(recordTitleLabel)
        recordTitleLabel.snp.makeConstraints{ make in
            
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            
        }
        
        let hStack = UIStackView(arrangedSubviews: [artistImageView, infomationArtistLabel])
        hStack.spacing = 10
        hStack.axis = .horizontal
        hStack.alignment = .top
        
        view.addSubview(hStack)
        hStack.snp.makeConstraints{ make in
            
            make.top.equalTo(recordImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            
        }
        
        artistImageView.snp.makeConstraints{ make in
            
            make.width.height.equalTo(100)
            
        }
        
        view.addSubview(recordCollectionView)
        recordCollectionView.snp.makeConstraints{ make in
            
            make.top.equalTo(hStack.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
        
        setupFirstContent()
                        
    }
    
    override func observeVM() {
        super.observeVM()
        
        let observationDidGetAllHardvardPersonalInformation = viewModel.observe(\.didGetAllHardvardPersonalInformation, options: [.new]) { [weak self] _,_ in
            guard let self = self else {return}
            
            DispatchQueue.main.async {

                self.artistImageView.image = self.viewModel.createImageAccordingToGender()
                self.infomationArtistLabel.text = self.viewModel.createNames()
                
            }
            
        }
        self.observations.append(observationDidGetAllHardvardPersonalInformation)
        
        let observationDidGetObjectAccordingToPerson = viewModel.observe(\.didGetObjectAccordingToPerson, options: [.new]) { [weak self] (_, key) in
            guard let self = self else {return}

            DispatchQueue.main.async {
            
                self.recordCollectionView.reloadData()
                
            }
            
        }
        self.observations.append(observationDidGetObjectAccordingToPerson)
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        Task {
            
            guard let personid = personid else {return}

            try await viewModel.getPersonalInformationModel(personID: personid)
            try await viewModel.getObjectAccordingToPerson(personID: personid)
            
            Loader.shared.hide()
            
        }
        
    }
    
    //MARK: Helpers
    private func setupFirstContent() {
        guard let firstRecordImage = firstRecordImage, let firstRecordTitle = firstRecordTitle else {return}

        recordImageView.image = firstRecordImage
        recordTitleLabel.text = firstRecordTitle
        
    }
    
    private func fade(toTitle: String, toImage: UIImage, showEffects: Bool) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            
            UIView.transition(with: self.recordImageView, duration: 0.5,
              options: .transitionCrossDissolve,
              animations: {
                
                self.recordImageView.image = toImage
                self.recordTitleLabel.text = toTitle
                
              },
              completion: nil
            )
            
            UIView.animate(withDuration: 0.5, delay: 0.0,
              options: .curveEaseOut,
              animations: {
                
                self.recordImageView.alpha = showEffects ? 1.0 : 0.0
                
              },
              completion: nil
            )
            
            
        }
        
      }
    
}

//MARK: Collection view data source
extension RecordInformationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionView.className, for: indexPath) as? HomeCollectionView else {return UICollectionViewCell()}
    
        cell.delegate = self
        
        return cell
        
    }
    
}

//MARK: HomeCollectionViewDelegate
extension RecordInformationViewController: HomeCollectionViewDelegate {
    
    func didTapOnImage(from: HomeCollectionView, withImage: UIImage) {
        
        guard let indexPath = self.recordCollectionView.indexPath(for: from) else {return}
        let title = viewModel.createHardvardMuseumObjectRecord(atIndexPath: indexPath)?.title ?? ""

        self.fade(toTitle: title, toImage: withImage, showEffects: true)
        
    }
    
}

//MARK: Collection willDisplay and endDisplay
extension RecordInformationViewController {
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                
        let cell = cell as! HomeCollectionView
        
        if let dataLoader = loadingOperations[indexPath] {
            
            if let image = dataLoader.image {
                
                cell.setupImage(image: image)
                loadingOperations.removeValue(forKey: indexPath)
                
            } else {
                
                dataLoader.completionBlock = {[unowned self] in
                    
                    cell.setupImage(image: dataLoader.image)
                    self.loadingOperations.removeValue(forKey: indexPath)

                }
                
            }
            
        } else {
            
            if let dataLoader = loadImage(at: indexPath) {
                
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
                dataLoader.completionBlock = {[unowned self] in
                    
                    cell.setupImage(image: dataLoader.image)
                    self.loadingOperations.removeValue(forKey: indexPath)
                    
                }
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let dataLoader = loadingOperations[indexPath] else {return}
        
        dataLoader.cancel()
        loadingOperations.removeValue(forKey: indexPath)
        
    }
    
}

//MARK: Collection prefetch data
extension RecordInformationViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if let _ = loadingOperations[indexPath] { return }
            guard let dataLoader = loadImage(at: indexPath) else {return}
            
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            guard let dataLoader = loadingOperations[indexPath] else {return}
            
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
            
        }
        
    }
    
    func loadImage(at index: IndexPath) -> DataLoadOperation? {
        
        guard let url = viewModel.createHardvardMuseumObjectRecord(atIndexPath: index)?.fullImageUrl else {return nil}
        
        return DataLoadOperation(url: url)
        
    }
    
}

//MARK: Collection flow layout
extension RecordInformationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 2
        let height = collectionView.frame.height - collectionView.contentInset.bottom
        
        return .init(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
        
    }
    
}
