//
//  String + Extension.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import Foundation
import CommonCrypto

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
    
    func challenge() -> String {
        guard let verifierData = self.data(using: String.Encoding.utf8) else { return "error" }
        var buffer = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = verifierData.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(verifierData.count), &buffer)
        }
        let hash = Data(_: buffer)
        
        let challenge = hash.base64EncodedData()
        return String(decoding: challenge, as: UTF8.self)
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
    }
    
}
