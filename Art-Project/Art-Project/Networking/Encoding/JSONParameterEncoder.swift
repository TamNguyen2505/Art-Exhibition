//
//  JSONParameterEncoder.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters?, and path: String?) throws {
        
        do {
            
            guard let parameters = parameters else {return}

            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            }
            
        } catch(let error) {
            
            print(error.localizedDescription)
            throw NetworkError.encodingFailed
            
        }
        
    }
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters?, path: String?, media: [Media]?) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.missingURL }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), let path = path {
            
            urlComponents.path = path
            urlRequest.url = urlComponents.url
            
        }
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        let lineBreak = "\r\n"
        
        var body = Data()
        
        if let parameters = parameters {
            
            for (key, value) in parameters {
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value as! String + lineBreak)")
                
            }
            
        }
        
        if let media = media {
            
            for photo in media {
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
                
            }
            
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        urlRequest.httpBody = body
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
        }
        
    }
    
    
}
