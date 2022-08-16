//
//  Media.swift
//  TableGit
//
//  Created by MINERVA on 25/07/2022.
//

import UIKit

public struct Media {
    
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else {return nil}
        
        self.data = data
        
    }
    
}
