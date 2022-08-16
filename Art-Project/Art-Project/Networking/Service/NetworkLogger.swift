//
//  NetworkLogger.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation
import UIKit

struct NetworkLogger: CustomDebugStringConvertible {
    //MARK: Properties
    public let urlRequest: URLRequest?
    public let data: Data?
    public let httpURLResponse: HTTPURLResponse?
    public let dateTime: Date?
    
    public var debugDescription: String {
        
        return description
        
    }

    public var prettyJSONString: NSString? {
        
        return data?.prettyJSONString
        
    }

    public var json: Any? {
        
        return data?.json
        
    }
    
    public var description: String {
        return """
        ====================================================================================================================
        URL: \(urlRequest?.url?.absoluteString ?? "nil")
        Status Code: \(httpURLResponse?.statusCode ?? -999)
        Method: \(urlRequest?.httpMethod ?? "nil")
        Header Request: \(String(data: try! JSONSerialization.data(withJSONObject: urlRequest?.allHTTPHeaderFields ?? [:], options: .prettyPrinted), encoding: .utf8) ?? "nil")
        ==============================
        Header Response: \(String(data: try! JSONSerialization.data(withJSONObject: self.httpURLResponse?.allHeaderFields ?? [:], options: .prettyPrinted), encoding: .utf8) ?? "nil")
        Body: \(String(describing: urlRequest?.httpBody?.prettyJSONString))
        \(data?.prettyJSONString ?? "nil")
        """
    }
        
    //MARK: Init
    init(urlRequest: URLRequest?, data: Data?, httpURLResponse: HTTPURLResponse?) {
        
        self.urlRequest = urlRequest
        self.data = data
        self.httpURLResponse = httpURLResponse
        
        if #available(iOS 13.0, *) {
            
            if let dateString = httpURLResponse?.value(forHTTPHeaderField: "Date") {
                
                let date = dateString.formatDate(format: DateFormatterType.EEE_DD_MMM_YYYY_HHMMSS_GMT)
                self.dateTime = date
                
            } else {
                
                self.dateTime = nil
                
            }
        } else {
            
            if let dateString = httpURLResponse?.allHeaderFields["Date"] as? String {
                
                let date = dateString.formatDate(format: DateFormatterType.EEE_DD_MMM_YYYY_HHMMSS_GMT)
                self.dateTime = date
                
            } else {
                
                self.dateTime = nil
                
            }
            
        }
        
    }

    //MARK: Heleprs
    func announce() {
        
        let infomation = String(reflecting: self)
        print(infomation)
        
    }

    
}


