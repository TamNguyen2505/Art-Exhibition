//
//  UserInformationViewModel.swift
//  Art-Project
//
//  Created by MINERVA on 30/08/2022.
//

import UIKit
import CoreData

class UserInformationViewModel {
    //MARK: Properties
    private let appDelegate: AppDelegate = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return AppDelegate()}
        return appDelegate
    }()
    
    private lazy var managedContext: NSManagedObjectContext = {
        let manager = appDelegate.persistentContainer.viewContext
        return manager
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<User> = {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "email", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: managedContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }()
    
    static let shared = UserInformationViewModel()
    
    //MARK: Init
    private init() {}
    
    //MARK: Features
    func fetch() -> [User]? {
        
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController.fetchedObjects
            
        } catch {
            fatalError("Failed to fetch: \(error)")
            
        }
        
    }
    
    func save(userName: String? = nil, fullName: String? = nil, email: String? = nil, profileImage: UIImage? = nil) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let userEntity = User(entity: entity, insertInto: managedContext)
        
        userEntity.userName = userName
        userEntity.fullName = fullName
        userEntity.email = email
        userEntity.profileImage = profileImage?.jpegData(compressionQuality: 0.5)
        
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Could not save. \(error)")
            return false
        }
        
    }
    
    func delete() -> Bool {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            try self.fetchedResultsController.performFetch()
            return true
            
        } catch let error as NSError {
            print("Could not delete. \(error)")
            return false
        }
        
    }
    
    
}
