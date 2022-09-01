//
//  Router.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation
import UIKit

public class Router {
    //MARK: Properties
    typealias EndPoint = EndPointType
    private var task: URLSessionTask?
    static let shared = Router()
    
    public struct RouterResult {
        var urlRequest: URLRequest?
        var data: Data?
        var response: URLResponse?
        var error: Error?
    }
    
    //MARK: Init
    private init() {}
    
    //MARK: Features
    func request(_ route: EndPoint) async throws -> RouterResult {
        
        let session = buildURLSession()
        let request = try self.buildRequest(from: route)
        
        task = session.dataTask(with: request)
        let (data, response) = try await session.data(for: request)
        
        self.task?.resume()
        
        let result = RouterResult(urlRequest: request, data: data, response: response, error: task?.error)
        
        return result
        
    }
    
    func upload(_ route: EndPoint) async throws -> RouterResult {
        
        let session = buildURLSession()
        let request = try self.buildRequest(from: route)
        
        task = session.dataTask(with: request)
        let (data, response) = try await session.data(for: request)
        
        self.task?.resume()
        
        let result = RouterResult(urlRequest: request, data: data, response: response, error: task?.error)
        
        return result
        
    }
    
    func download(_ route: EndPoint) async throws -> RouterResult {
        
        let session = buildURLSession()
        let request = try self.buildRequest(from: route)
        
        task = session.dataTask(with: request)
        let (url, response) = try await session.download(for: request)
        let data = try? Data(contentsOf: url)
        
        self.task?.resume()
        
        let result = RouterResult(urlRequest: request, data: data, response: response, error: task?.error)
        
        return result
        
    }
    
    func streamDownload(_ route: EndPoint) async throws -> (result: RouterResult, stream: URLSession.AsyncBytes) {
        
        let session = buildURLSession()
        let request = try self.buildRequest(from: route)
        
        task = session.dataTask(with: request)
        let (stream, response ) = try await session.bytes(for: request)
        
        self.task?.resume()
        
        let result = RouterResult(urlRequest: request, response: response, error: task?.error)
        
        return (result, stream)
        
    }
    
    func cancel() {
        
        self.task?.cancel()
        self.task = nil
        
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
                
            case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters):
                
                try self.configureParameters(
                    path: route.path,
                    bodyParameters: bodyParameters,
                    bodyEncoding: bodyEncoding,
                    urlParameters: urlParameters,
                    request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters, let bodyEncoding, let urlParameters, let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(
                    path: route.path,
                    bodyParameters: bodyParameters,
                    bodyEncoding: bodyEncoding,
                    urlParameters: urlParameters,
                    request: &request)
                
            case .uploadFile(let bodyParameters, let bodyEncoding, let additionHeaders, let media):
                
                guard let media = media else {throw NetworkError.parametersNil}
                
                self.addAdditionalHeaders(additionHeaders, request: &request)
                try self.configureParametersWithMeida(
                    path: route.path,
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
    
    fileprivate func configureParameters(path: String?, bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters, path: path)
            
        } catch {
            
            throw NetworkError.configuringParametersFailed
            
        }
        
    }
    
    fileprivate func configureParametersWithMeida(path: String?, bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, media: [Media]?, request: inout URLRequest) throws {
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

