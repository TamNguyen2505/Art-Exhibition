//
//  EndPointType.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

protocol EndPointType {
    
    var baseURL: URL {get}
    var path: String? {get}
    var httpMethod: HTTPMethod {get}
    var task: HTTPTask {get}
    var headers: HTTPHeaders {get}
    var cachePolicy: URLRequest.CachePolicy { get }
    
}
