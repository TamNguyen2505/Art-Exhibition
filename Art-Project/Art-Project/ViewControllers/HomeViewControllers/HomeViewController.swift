//
//  HomeViewController.swift
//  TableGit
//
//  Created by MINERVA on 09/08/2022.
//

import UIKit

class HomeViewController: BaseViewController {
    //MARK: Properties
    private let fullPhotoItem: NSCollectionLayoutItem = {
        let layout = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2 / 3)))
        layout.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        return layout
    }()
    
    private let mainItem: NSCollectionLayoutItem = {
        let layout = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        layout.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        return layout
    }()
    
    private let pairItem: NSCollectionLayoutItem = {
        let layout = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        layout.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        return layout
    }()
    
    private lazy var trailingGroup: NSCollectionLayoutGroup = {
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1.0)), subitem: pairItem, count: 2)
        return group
    }()
    
    private lazy var mainWithPairGroup: NSCollectionLayoutGroup = {
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4 / 9)), subitems: [mainItem, trailingGroup])
        return group
    }()
    
    private let tripleItem: NSCollectionLayoutItem = {
        let layout = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        layout.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        return layout
    }()
    
    private lazy var tripleGroup: NSCollectionLayoutGroup = {
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitem: tripleItem, count: 3)
        return group
    }()
    
    private lazy var mainWithPairReversedGroup: NSCollectionLayoutGroup = {
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItem])
        return group
    }()
    
    private lazy var nestedGroup: NSCollectionLayoutGroup = {
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(16/9)), subitems: [fullPhotoItem, mainWithPairGroup, tripleGroup, mainWithPairReversedGroup])
        return group
    }()
    
    private lazy var titleSection: NSCollectionLayoutBoundarySupplementaryItem = {
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }()
        
    private lazy var artLayOut: UICollectionViewLayout = {
        let sectionProvider = { [weak self] (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else {return nil}

            let section = NSCollectionLayoutSection(group: self.nestedGroup)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.boundarySupplementaryItems = [self.titleSection]
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }()
    
    private lazy var artCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: artLayOut)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HomeCollectionView.self, forCellWithReuseIdentifier: HomeCollectionView.className)
        collectionView.register(HomeHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderCollectionView.className)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        return collectionView
    }()
    
    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath: DataLoadOperation]()

    private let viewModel = HomeViewModel()
    
    //MARK: Init
    override func setupUI() {
        super.setupUI()
        
        Loader.shared.show()
        
        view.addSubview(artCollectionView)
        artCollectionView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
    }
    
    override func observeVM() {
        super.observeVM()
        
        let observationDidGetAllHardvardMuseumObjectModel = viewModel.observe(\.didGetAllHardvardMuseumObjectModel, options: [.new]) {[weak self] _,_ in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                
                self.artCollectionView.reloadData()
                
            }

        }
        self.observations.append(observationDidGetAllHardvardMuseumObjectModel)
        
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        Task {
            
            await viewModel.getHardvardMuseumObjectModel()
            Loader.shared.hide()

        }
        
    }
    
}

//MARK: Collection view data source
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return viewModel.numberOfSections()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeHeaderCollectionView.className,
                for: indexPath)
            
            guard let typedHeaderView = headerView as? HomeHeaderCollectionView, let viewModel = viewModel.createHomeHeaderCollectionViewModel(atIndexPath: indexPath) else { return headerView }
            
            typedHeaderView.updateContent(viewModel: viewModel)
            
            return typedHeaderView
            
        default:
            assert(false, "Invalid element type")
            
        }
        
    }
    
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
extension HomeViewController: HomeCollectionViewDelegate {
    
    func didTapOnImage(from: HomeCollectionView, withImage: UIImage) {
        
        guard let indexPath = self.artCollectionView.indexPath(for: from) else {return}
        
        let targetVC = RecordInformationViewController()
        
        targetVC.hideTabBarController = true
        targetVC.personid = viewModel.createPersonID(atIndexPath: indexPath)
        targetVC.firstRecordTitle = viewModel.createHardvardMuseumObjectRecord(atIndexPath: indexPath)?.title
        targetVC.firstRecordImage = withImage
        
        self.navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
}

//MARK: Collection willDisplay and endDisplay
extension HomeViewController {
        
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
extension HomeViewController: UICollectionViewDataSourcePrefetching {
    
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

