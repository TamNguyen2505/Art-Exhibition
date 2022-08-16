//
//  RecordInfomationViewModel.swift
//  TableGit
//
//  Created by MINERVA on 10/08/2022.
//

import UIKit

class RecordInfomationViewModel: NSObject {
    //MARK: Properties
    private let networkManager = NetworkManager()
    private var personalInfomationModel: HardvardMuseumPerson? {
        didSet {
            didGetAllHardvardPersonalInformation = true
        }
    }
    private var hardvardMuseumObjectOfPerson: HardvardMuseumObject? {
        didSet {
            didGetObjectAccordingToPerson = true
        }
    }
    
    @objc dynamic var didGetAllHardvardPersonalInformation = false
    @objc dynamic var didGetObjectAccordingToPerson = false

    //MARK: Features
    func getPersonalInformationModel(personID: Int) async throws {
        
        let personID = String(personID)
        let parameters: [String: Any] = ["apikey": URLs.keyAPI]
        
        do {
            
            async let personalInfomationModel = try await networkManager.callAndParseAPI(accordingTo: .getPeronalInformation(path: personID, parameters: parameters), parseInto: HardvardMuseumPerson.self)
            self.personalInfomationModel = try await personalInfomationModel
            
        } catch {
            
        }
        
    }
    
    func getObjectAccordingToPerson(personID: Int) async throws {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI,
                                         "person": personID]

        do {
            
            async let hardvardMuseumObjectOfPerson = try await networkManager.callAndParseAPI(accordingTo: .getObjectAccordingToPerson(parameters: parameters), parseInto: HardvardMuseumObject.self)
            self.hardvardMuseumObjectOfPerson = try await hardvardMuseumObjectOfPerson
            
        } catch {
            
        }
        
    }
    
    
}

extension RecordInfomationViewModel {

    func createImageAccordingToGender() -> UIImage? {
        
        guard didGetAllHardvardPersonalInformation else {return nil}
        
        if self.personalInfomationModel?.gender == "male" {
            
            return UIImage(named: "icons8-man-artist")
            
        } else {
            
            return UIImage(named: "icons8-woman-artist")
            
        }
        
    }
    
    func createNames() -> String? {
        
        guard didGetAllHardvardPersonalInformation else {return nil}
        
        guard let names = self.personalInfomationModel?.names else {return nil}
        
        var stringName = [String]()
        
        for name in names where name.displayname != nil {
            guard let displayName = name.displayname else {continue}
            
            stringName.append(displayName)
            
        }
        
        return stringName.joined(separator: " - ")

    }
    
}

extension RecordInfomationViewModel {
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard didGetObjectAccordingToPerson else {return 1}
        
        return self.hardvardMuseumObjectOfPerson?.records?.count ?? 1
        
    }
    
    func createHardvardMuseumObjectRecord(atIndexPath: IndexPath) -> HomeCollectionCellViewModel? {
        
        guard didGetObjectAccordingToPerson, let model = self.hardvardMuseumObjectOfPerson?.records?[atIndexPath.item] else {return nil}
        
        return HomeCollectionCellViewModel(model: model)
        
    }
    
    
}
