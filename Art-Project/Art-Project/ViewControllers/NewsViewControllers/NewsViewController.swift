//
//  NewsViewController.swift
//  TableGit
//
//  Created by MINERVA on 03/08/2022.
//

import UIKit

class NewsViewController: BaseViewController {
    //MARK: Properties
    private let topScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var newsTableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableCell.self, forCellReuseIdentifier: NewsTableCell.className)
        table.delegate = self
        table.dataSource = self
        table.prefetchDataSource = self
        table.estimatedRowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        return table
    }()
    
    private let viewModel = NewsViewModel()
 
    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath: DataLoadOperation]()
    
    //MARK: View cycles
    override func setupUI() {
        super.setupUI()
        
        Loader.shared.show()
        
        view.addSubview(topScrollView)
        topScrollView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            
        }
        
        setupUIForTopTab()
        
        view.addSubview(newsTableView)
        newsTableView.snp.makeConstraints{ make in
            
            make.top.equalTo(topScrollView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
        
    }
    
    override func observeVM() {
        super.observeVM()
        
        let observationDidGetAllHardvardMuseumObjectModel = viewModel.observe(\.didGetAllHardvardMuseumObjectModel, options: [.new]) {[weak self] _,_ in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                
                self.newsTableView.reloadData()
                
            }

        }
        self.observations.append(observationDidGetAllHardvardMuseumObjectModel)
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        Task {
            
            await viewModel.getHardvardMuseumObjectModel(accordingTo: 0)
            Loader.shared.hide()

        }
        
    }
    
    //MARK: Helpers
    private func setupUIForTopTab() {
        
        var labels = [UILabel]()
        
        for index in 1...10 {
            
            let label = UILabel()
            label.textColor = .darkGray
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = "Object \(index)"
            labels.append(label)
            
        }
        
        let hStack = UIStackView(arrangedSubviews: labels)
        hStack.spacing = 30
        hStack.axis = .horizontal
        
        topScrollView.addSubview(hStack)
        hStack.snp.makeConstraints{ make in
            
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            
        }
        
    }
    
    
}

//MARK: Table view data sources
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemsInSection(section: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableCell.className, for: indexPath) as! NewsTableCell
        
        guard let viewModel = viewModel.createHardvardMuseumObjectRecord(atIndexPath: indexPath) else {return cell}
        
        cell.updateContent(viewModel: viewModel)
        
        return cell
        
    }
    
    
}

//MARK: Table delegate
extension NewsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: Table willDisplay and endDisplay
extension NewsViewController {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! NewsTableCell
        
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let dataLoader = loadingOperations[indexPath] else {return}
        
        dataLoader.cancel()
        loadingOperations.removeValue(forKey: indexPath)
        
    }
    
}


//MARK: UITableViewDataSourcePrefetching
extension NewsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if let _ = loadingOperations[indexPath] { return }
            guard let dataLoader = loadImage(at: indexPath) else {return}
            
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            guard let dataLoader = loadingOperations[indexPath] else {return}
            
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
            
        }
        
    }
    
    func loadImage(at index: IndexPath) -> DataLoadOperation? {
        
        guard let url = viewModel.createHardvardMuseumObjectRecord(atIndexPath: index)?.imageUrl else {return nil}
        
        return DataLoadOperation(url: url)
        
    }
    
}
