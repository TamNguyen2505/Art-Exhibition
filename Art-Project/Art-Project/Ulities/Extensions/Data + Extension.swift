//
//  Data + Extension.swift
//  TableGit
//
//  Created by MINERVA on 13/07/2022.
//

import Foundation

extension Data {
    
    var prettyJSONString: NSString? {
        
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []), let prettyPrintedData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) else { return nil }
        
        return NSString(data: prettyPrintedData, encoding: String.Encoding.utf8.rawValue)
        
    }
    
    var json: Any? {
        
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
        
    }
    
    mutating func append(_ string: String) {
        
        guard let data = string.data(using: .utf8) else {return}
        
        append(data)
        
    }
    
}
