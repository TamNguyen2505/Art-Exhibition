//
//  NewsViewModel.swift
//  TableGit
//
//  Created by MINERVA on 03/08/2022.
//

import UIKit

//MARK: API
class NewsViewModel: NSObject {
    //MARK: Properties
    private let networkManager = NetworkManager()
    private var hardvardMuseumObjectRecords: [HardvardMuseumObjectRecord]? = nil {
        didSet {
            didGetAllHardvardMuseumObjectModel = true
        }
    }
    @objc dynamic var didGetAllHardvardMuseumObjectModel = false
    
    //MARK: Features
    func getHardvardMuseumObjectModel(accordingTo page: Int) async {
        
        let pageToString = String(page)
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:\(pageToString)",
                                         "size": 200]

        
        self.hardvardMuseumObjectRecords = await withTaskGroup(of: HardvardMuseumObject?.self, returning: [HardvardMuseumObjectRecord]?.self) { group in
            
            group.addTask{
                
                do {
                    
                    return try await self.networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parameters), parseInto: HardvardMuseumObject.self)
                    
                } catch {
                    
                    return nil
                    
                }
                
            }
            
            var records: [HardvardMuseumObjectRecord]?
            
            for await result in group {
                guard let result = result else {continue}
                
                records = result.records
                
            }
            
            return records
                        
        }
        
        
    }
    
}

extension NewsViewModel {
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard didGetAllHardvardMuseumObjectModel else {return 1}
        
        return self.hardvardMuseumObjectRecords?.count ?? 1
        
    }
    
    func createHardvardMuseumObjectRecord(atIndexPath: IndexPath) -> NewsTableCellViewModel? {
        
        guard didGetAllHardvardMuseumObjectModel, let model = self.hardvardMuseumObjectRecords?[atIndexPath.row] else {return nil}
        
        return NewsTableCellViewModel(model: model)
        
    }
    
    
}
