//
//  String + Extension.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import Foundation
import CommonCrypto
import CryptoKit

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
    
    func pbkdf2(prf: CCPseudoRandomAlgorithm = CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256), rounds: Int = 5000) -> String? {
        guard let passwordData = self.data(using: .utf8) else { return nil }
        
        let randomSymmetricKey = SymmetricKey(size: .bits256)
        let saltData = randomSymmetricKey.withUnsafeBytes { Data($0) }

        var derivedKeyData = Data(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        let derivedCount = derivedKeyData.count
        
        let derivationStatus: Int32 = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
            
            let keyBuffer: UnsafeMutablePointer<UInt8> =
            derivedKeyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
            
            return saltData.withUnsafeBytes { saltBytes -> Int32 in
                let saltBuffer: UnsafePointer<UInt8> = saltBytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
                return CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    self,
                    passwordData.count,
                    saltBuffer,
                    saltData.count,
                    prf,
                    UInt32(rounds),
                    keyBuffer,
                    derivedCount)
                
            }
            
        }
        
        guard derivationStatus == kCCSuccess else {return nil}
        
        return derivedKeyData.base64EncodedString()
        
        
    }
    
}
