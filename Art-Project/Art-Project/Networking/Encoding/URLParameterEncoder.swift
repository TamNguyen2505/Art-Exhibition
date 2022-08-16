//
//  URLParameterEncoder.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters?, and path: String?) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false) {
            
            if let path = path {
                
                urlComponents.path = path
                
            }
            
            if let parameters = parameters {
                
                urlComponents.queryItems = [URLQueryItem]()
                
                for (key,value) in parameters {
                    
                    let queryItem = URLQueryItem(
                        name: key,
                        value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed))
                    urlComponents.queryItems?.append(queryItem)
                    
                }
                
            }
            
            urlRequest.url = urlComponents.url
            
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
        }
        
        
    }
    
}
