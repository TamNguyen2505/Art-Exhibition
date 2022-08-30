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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
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
    
    func save(user: User) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let userEntity = User(entity: entity, insertInto: managedContext)
        
        userEntity.userName = user.userName
        userEntity.fullName = user.fullName
        userEntity.email = user.email
        userEntity.profileImage = user.profileImage
        
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
