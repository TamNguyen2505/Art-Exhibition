//
//  Bundle + Extension.swift
//  Art-Project
//
//  Created by Nguyen Minh Tam on 04/09/2022.
//

import Foundation

extension Bundle {
    
    public enum APIKey: String {
        case ZALO_API_KEY = "ZALO_API_KEY"
        case GOOGLE_MAP_API_KEY = "GOOGLE_MAP_API_KEY"
        case HARVARD_MUSEUM_API_KEY = "HARVARD_MUSEUM_API_KEY"
        
    }
    
    public static func getAPIKeyInConfiguration(apiKey: APIKey) -> String {
        let apiKey = apiKey.rawValue
        guard let key = self.main.infoDictionary?[apiKey] as? String else {return ""}
        
        return key
        
    }
    
}
