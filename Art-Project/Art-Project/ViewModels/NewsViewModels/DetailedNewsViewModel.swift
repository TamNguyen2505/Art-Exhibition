//
//  DetailedNewsViewModel.swift
//  TableGit
//
//  Created by MINERVA on 04/08/2022.
//

import UIKit
import Combine

//MARK: API
class DetailedNewsViewModel {
    //MARK: Properties
    private let networkManager = NetworkManager()
    var detailedInformationOfObject = DetailedNewsModel()
    var cancellable: AnyCancellable?
    @Published var percent: Float = 0.0
    
    //MARK: Features
    func getDetailedInformationOfObject(objectID: String) async {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI]
        
        do {
            
            self.detailedInformationOfObject = try await networkManager.callAndParseAPI(accordingTo: .getDetailedInformationOfObject(path: objectID, parameters: parameters), parseInto: DetailedNewsModel.self) ?? DetailedNewsModel()
            
        } catch {
            
            
        }
        
    }
    
    func streamDownloadImage(imageID: String) async throws -> UIImage? {
        
        let fullTime = 5.0.convertMinuteToMilisecond()
        let startTime = CFAbsoluteTimeGetCurrent()
        var acumalatorPercent = 0.0
        
        cancellable = networkManager.$byte.sink { [weak self] (byte) in
            guard let self = self, Double(byte) != 0.0 else {return}
            
            let endTime = CFAbsoluteTimeGetCurrent() - startTime
            let estimatedPercent = endTime / fullTime
            let estimateRatePercent = estimatedPercent * Double(byte)
            acumalatorPercent += estimateRatePercent
            
            let normalziedNumber = 100000.0 + 1000000000.0 * estimatedPercent
            let roundedNumber = acumalatorPercent / normalziedNumber
                        
            self.percent = Float(min(roundedNumber, 1.0))
                                                
        }
        
        do {
                        
            let baseURL = imageID + URLs.OBJECT_FULL_IMAGE
            
            guard let data = try await networkManager.streamDownloadData(accordingTo: .downloadFullImageObject(baseURL: baseURL)) else {return nil}

            self.percent = 1.0
            cancellable?.cancel()
            
            return UIImage(data: data)
            
        } catch {
            
            throw error
            
        }
        
    }
    
    
    func createPercentString(value: Float) -> String {
        
        let roundedValue = (value * 100).rounded(.towardZero)
        let string = String(roundedValue) + "%"
        return string
        
    }
    
    
}

