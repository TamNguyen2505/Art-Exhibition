//
//  HomeCollectionCellViewModel.swift
//  TableGit
//
//  Created by MINERVA on 10/08/2022.
//

import Foundation

struct HomeCollectionCellViewModel {
    //MARK: Properties
    private var model: HardvardMuseumObjectRecord
    
    //MARK: Init
    init(model: HardvardMuseumObjectRecord) {
        
        self.model = model
        
    }
    
    //MARK: Expected values
    var fullImageUrl: URL? {
        
        guard let id = model.images?.first?.iiifbaseuri, let url = URL(string: id + URLs.OBJECT_FULL_IMAGE) else {return nil}
        return url
        
    }
    
    var portraitImage: URL? {
        
        guard let id = model.images?.first?.iiifbaseuri, let url = URL(string: id + URLs.OBJRCT_PORTRAIT_IMAGE) else {return nil}
        return url
        
    }
    
    var title: String {
        
        return model.title ?? "None"
        
    }
    
}
