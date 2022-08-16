//
//  NetworkManager.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import UIKit
import Combine

enum NetworkResponse:String {
    
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    
}

enum NetworkResult<String>{
    
    case success
    case failure(String)
    
}

class NetworkManager {
    //MARK: Properties
    private let router = Router<BaseEnpoint>()
    @Published var byte = UInt8()
    
    //MARK: Features
    public func callAndParseAPI<D: Codable>(accordingTo caseEndPoint: BaseEnpoint, parseInto model: D.Type) async throws -> D? {
        
        let routerResponse = try await router.request(caseEndPoint)
        
        guard let response = routerResponse.response as? HTTPURLResponse else {return nil}
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            guard let responseData = routerResponse.data else {return nil}
            
            do {
                
                async let asyncDecodedModel = try? await self.map(from: responseData, to: model)
                let decodedModel = await asyncDecodedModel
                
                let information = NetworkLogger(urlRequest: routerResponse.urlRequest, data: routerResponse.data, httpURLResponse: response)
                information.announce()
                            
                return decodedModel
                
            }
            
        case .failure(_):
            
            return nil
            
        }
        
    }
    
    public func uploadFileAndParseResponse<D: Codable>(accordingTo caseEndPoint: BaseEnpoint, parseInto model: D.Type) async throws -> D? {
        
        let routerResponse = try await router.upload(caseEndPoint)
        
        guard let response = routerResponse.response as? HTTPURLResponse else {return nil}
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            guard let responseData = routerResponse.data else {return nil}
            
            do {
                
                async let asyncDecodedModel = try? await self.map(from: responseData, to: model)
                let decodedModel = await asyncDecodedModel
                
                let information = NetworkLogger(urlRequest: routerResponse.urlRequest, data: routerResponse.data, httpURLResponse: response)
                information.announce()
                            
                return decodedModel
                
            }
                                    
        case .failure(_):
            
            return nil
            
        }
        
        
    }
    
    public func downloadData(accordingTo caseEndPoint: BaseEnpoint) async throws -> Data? {
        
        let routerResponse = try await router.download(caseEndPoint)
        
        guard let response = routerResponse.response as? HTTPURLResponse else {return nil}
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            guard let responseData = routerResponse.data else {return nil}
            
            let information = NetworkLogger(urlRequest: routerResponse.urlRequest, data: routerResponse.data, httpURLResponse: response)
            information.announce()
                        
            return responseData
                                    
        case .failure(_):
            
            return nil
            
        }
        
    }
    
    public func streamDownloadData(accordingTo caseEndPoint: BaseEnpoint) async throws -> Data? {
        
        let routerResponse = try await router.streamDownload(caseEndPoint)
        
        guard let response = routerResponse.response as? HTTPURLResponse else {return nil}
        let result = handleNetworkResponse(response)

        switch result {
        case .success:
            let streamData = routerResponse.stream
            var iterator = streamData.makeAsyncIterator()

            var accumulatorData = Data()
                        
            while let nextBytes = try await iterator.next() {
                
                self.byte = nextBytes
                accumulatorData.append(nextBytes)
                
            }
               
            let information = NetworkLogger(urlRequest: routerResponse.urlRequest, data: accumulatorData, httpURLResponse: response)
            information.announce()
            
            return accumulatorData
                                    
        case .failure(_):
            
            return nil
            
        }
        
    }
        
    //MARK: Helpers
    public func map<D: Codable>(from data: Data, to type: D.Type, decoder: JSONDecoder = JSONDecoder()) async throws -> D {

        do {
            
            return try decoder.decode(type, from: data)
            
        } catch(let error) {
            
            print(error.localizedDescription)
            throw error
            
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<String>{
        
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
            
        }
    }
    
}

