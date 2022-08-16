//
//  Router.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation
import UIKit
import Combine

public typealias NetworkRouterCompletion = (_ urlRequest: URLRequest?, _ data: Data?, _ response: URLResponse?, _ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint) async throws -> (urlRequest: URLRequest?, data: Data?, response: URLResponse?, error: Error?)
    func upload(_ route: EndPoint) async throws -> (urlRequest: URLRequest?, data: Data?, response: URLResponse?, error: Error?)
    func download(_ route: EndPoint) async throws -> (urlRequest: URLRequest?, data: Data?, response: URLResponse?, error: Error?)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
 
    //MARK: Properties
    private var task: URLSessionTask?
    
    //MARK: Features
    func request(_ route: EndPoint) async throws -> (urlRequest: URLRequest?, data: Data?, response: URLResponse?, error: Error?) {
     
        let session = buildURLSession()
        let request = try self.buildRequest(from: route)
        
        task = session.dataTask(with: request)
        let (data, response) = try await session.data(for: request)
 
        self.task?.resume()
        
        return (request, data, response, task?.error)
    }
    
    func upload(_ route: EndPoint) async throws -> (urlRequest: URLRequest?, data: Data?, response: URLResponse?, error: Error?) {
        
        let session = buildURLSession()
        let request = try self.buildRequest(from: route)
                
        task = session.dataTask(with: request)
        let (data, response) = try await session.data(for: request)
        
        self.task?.resume()
        
        return (request, data, response, task?.error)
        
    }
    
    func download(_ route: EndPoint) async throws -> (urlRequest: URLRequest?, data: Data?, response: URLResponse?, error: Error?){
        
        let session = buildURLSession()
        let request = try self.buildRequest(from: route)
        
        task = session.dataTask(with: request)
        let (url, response) = try await session.download(for: request)
        let data = try? Data(contentsOf: url)
        
        self.task?.resume()
        
        return (request, data, response, task?.error)
        
    }
    
    func streamDownload(_ route: EndPoint) async throws -> (urlRequest: URLRequest?, stream: URLSession.AsyncBytes, response: URLResponse?, error: Error?) {
        
        let session = buildURLSession()
        let request = try self.buildRequest(from: route)
        
        task = session.dataTask(with: request)
        let (stream, response ) = try await session.bytes(for: request)
        
        self.task?.resume()
        
        return (request, stream, response, task?.error)
        
    }
    
    func cancel() {
        
        self.task?.cancel()
        
    }
    
    //MARK: Helpers
    fileprivate func buildURLSession() -> URLSession {
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5*60
        
        let session = URLSession(configuration: config)
        
        return session
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(path: route.path,
                                             bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(path: route.path,
                                             bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .uploadFile(let bodyParameters,
                             let bodyEncoding,
                             let additionHeaders,
                             let media):
                
                guard let media = media else {throw NetworkError.parametersNil}

                self.addAdditionalHeaders(additionHeaders, request: &request)
                try self.configureParametersWithMeida(path: route.path,
                                                      bodyParameters: bodyParameters,
                                                      bodyEncoding: bodyEncoding,
                                                      media: [media],
                                                      request: &request)
                
            case .downloadFile:
                
                break
                
            }
            
            return request
            
        } catch {
            
            throw NetworkError.buildingRequestUrlFailed
            
        }
        
    }
    
    fileprivate func configureParameters(path: String?,
                                         bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters, path: path)
            
        } catch {
            
            throw NetworkError.configuringParametersFailed
            
        }
        
    }
    
    fileprivate func configureParametersWithMeida(path: String?,
                                                  bodyParameters: Parameters?,
                                                  bodyEncoding: ParameterEncoding,
                                                  media: [Media]?,
                                                  request: inout URLRequest) throws {
        
        do {
            
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, path: path, media: media)
            
        } catch {
            
            throw NetworkError.configuringParametersFailed
            
        }
        
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        
        guard let headers = additionalHeaders else { return }
        
        for (key, value) in headers {
            
            request.setValue(value, forHTTPHeaderField: key)
            
        }
        
    }
    
}

