//
//  HomeHeaderCollectionViewModel.swift
//  TableGit
//
//  Created by MINERVA on 10/08/2022.
//

import Foundation

struct HomeHeaderCollectionViewModel {
    //MARK: Properties
    private var model: HardvardMuseumObjectInfo
    
    //MARK: Init
    init(model: HardvardMuseumObjectInfo) {
        
        self.model = model
        
    }
    
    //MARK: Expected values
    var totalOfPictures: String {
        
        if let total = model.totalrecords {
            
            return String(total) + " pictures"
            
        } else {
            
            return "no picture"
            
        }
        
    }
    
}
