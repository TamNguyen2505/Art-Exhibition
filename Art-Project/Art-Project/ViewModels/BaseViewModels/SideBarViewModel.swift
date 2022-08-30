//
//  SideBarViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 29/08/2022.
//

import UIKit

class SideBarViewModel {
    //MARK: Properties
    var sectionData: [SideBarSectionModel] {
        return [
            SideBarSectionModel(title: LocalizableManager.getLocalizableString(key: .text_public_features), itemImage: nil,
                                subItems: [
                                    SideBarSectionModel(title: LocalizableManager.getLocalizableString(key: .text_map_feature), itemImage: .init(named: "icons8-map-marker"), subItems: nil),
                                    SideBarSectionModel(title: LocalizableManager.getLocalizableString(key: .text_chat_feature), itemImage: .init(named: "icons8-chat"), subItems: nil)]),
            
            SideBarSectionModel(title: LocalizableManager.getLocalizableString(key: .text_advanced_features), itemImage: nil,
                                subItems: [
                                    SideBarSectionModel(title: LocalizableManager.getLocalizableString(key: .text_eKYC_feature), itemImage: .init(named: "icons8-face-scanner"), subItems: nil),
                                    SideBarSectionModel(title: LocalizableManager.getLocalizableString(key: .text_AR_feature), itemImage: .init(named: "icons8-AR"), subItems: nil)])
            ]
    }
    
    //MARK: Features
    func numberOfSection() -> Int {
        
        return sectionData.count
    
    }
    
    func dataAtSection(section: Int) -> SideBarSectionModel {
        
        return sectionData[section]
        
    }
    
    func numberOfItemAtSection(section: Int) -> Int {
        
        return sectionData[section].subItems?.count ?? 0
        
    }
    
    func dataAtItem(index: IndexPath) -> SideBarSectionModel {
        
        return sectionData[index.section].subItems?[index.item] ?? SideBarSectionModel(title: "", itemImage: nil, subItems: nil)
        
    }
    
}
