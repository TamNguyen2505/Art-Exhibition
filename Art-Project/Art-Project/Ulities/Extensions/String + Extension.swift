//
//  String + Extension.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import Foundation

extension String {
    
    public static func className(aClass: AnyClass) -> String {
        
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
        
    }
    
    func formatDate(format: String = DateFormatterType.YYMMDD) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func formatDateToString(format: String = DateFormatterType.YYMMDD) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+07")
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
        
    }
    
}
