//
//  SideBarViewController.swift
//  TableGit
//
//  Created by MINERVA on 29/07/2022.
//

import UIKit

class SideBarViewController: BaseViewController {
    //MARK: Properties
    private lazy var titlViewLabel: UILabel = {
        let label = UILabel()
        label.attributedText = createCommonAttributedString()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let appearance = UICollectionLayoutListConfiguration.Appearance.insetGrouped
    
    private lazy var collectionLayout: UICollectionViewLayout = {
        return UICollectionViewCompositionalLayout { [unowned self] section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: self.appearance)
            config.headerMode = .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.delegate = self
        return collection
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SideBarSectionModel>? = nil
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(named: "logout")?.rotate(radians: -.pi / 2)
        button.setImage(image, for: .normal)
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleEventFromLogOutButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let authenticationViewModel = AuthenticationViewModel.shared
    private let sideBarViewModel = SideBarViewModel()
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(titlViewLabel)
        titlViewLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            
            make.top.equalTo(titlViewLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            
        }
        
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints{ make in
            
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
        
        configureDataSource()
        
    }
    
    //MARK: Actions
    @objc func handleEventFromLogOutButton(_ sender: UIButton) {
        
        authenticationViewModel.logOut()
        
    }
    
}

//MARK: Collection data source
extension SideBarViewController {
    
    func configureDataSource() {
        
        let headerRegistration = UICollectionView.CellRegistration<SideBarHeadCollectionCell, SideBarSectionModel> { cell,indexPath,itemIdentifier in
            
            cell.setupContent(title: itemIdentifier.title)
            
        }
        
        let cellRegistration = UICollectionView.CellRegistration<SideBarCollectionCell, SideBarSectionModel> { cell,indexPath,itemIdentifier in
            
            cell.setupContent(data: itemIdentifier)
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, SideBarSectionModel>(collectionView: collectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, item: SideBarSectionModel) -> UICollectionViewCell? in
            
            if indexPath.item == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }
        
        guard let dataSource = dataSource else {return}
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, SideBarSectionModel>()
        let sections = Array(0..<sideBarViewModel.numberOfSection())
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        for section in sections {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<SideBarSectionModel>()
            let headerItem = sideBarViewModel.dataAtSection(section: section)
            sectionSnapshot.append([headerItem])
            
            let items = Array(0..<sideBarViewModel.numberOfItemAtSection(section: section)).map { sideBarViewModel.dataAtItem(index: .init(item: $0, section: section)) }
            sectionSnapshot.append(items, to: headerItem)
            sectionSnapshot.expand([headerItem])
            dataSource.apply(sectionSnapshot, to: section)
        }
        
    }
    
}

//MARK: Collection delegate
extension SideBarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.item == 0, let dataSource = dataSource, let cell = collectionView.cellForItem(at: indexPath) as? SideBarHeadCollectionCell else {return}

        var sectionSnapshot = dataSource.snapshot(for: indexPath.section)
        let items = sectionSnapshot.items
        
        guard let rootItem = items.first else {return}

        if sectionSnapshot.isExpanded(rootItem) {

            sectionSnapshot.collapse([rootItem])
            dataSource.apply(sectionSnapshot, to: indexPath.section, animatingDifferences: true)
            cell.rotateImage(arrowDown: false)

        } else {

            sectionSnapshot.expand([rootItem])
            dataSource.apply(sectionSnapshot, to: indexPath.section, animatingDifferences: true)
            cell.rotateImage(arrowDown: true)

        }
                
    }
    
}
