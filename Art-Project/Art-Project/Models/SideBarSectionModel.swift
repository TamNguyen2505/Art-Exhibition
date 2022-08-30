//
//  SideBarSectionModel.swift
//  Art-Project
//
//  Created by MINERVA on 29/08/2022.
//

import UIKit

struct SideBarSectionModel: Hashable {
    let title: String?
    let itemImage: UIImage?
    let subItems: [SideBarSectionModel]?
    
    init(title: String? = nil, itemImage: UIImage? = nil, subItems: [SideBarSectionModel]? = nil) {
        
        self.title = title
        self.itemImage = itemImage
        self.subItems = subItems
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: SideBarSectionModel, rhs: SideBarSectionModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
}
