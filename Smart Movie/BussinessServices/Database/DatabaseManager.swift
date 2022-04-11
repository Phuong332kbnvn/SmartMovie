//
//  DatabaseManager.swift
//  Smart Movie
//
//  Created by Phuong on 18/03/2022.
//

import Foundation
import CoreData

final class DatabaseManager {
    static let share = DatabaseManager()
    
    private let modelName = "Smart_Movie"
    private let favoriteEntity = "Favorite"
    
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            return nil
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            return nil
        }
        return managedObjectModel

        
    }()
    
    private lazy var coordinator: NSPersistentStoreCoordinator = {

        let persitentCoodinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
                
                var documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let persitentStoreURL = documentDirectoryURL.appendingPathComponent("\(modelName).sqlite")
                
                do {
                    let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                                         NSInferMappingModelAutomaticallyOption: true]
                    try persitentCoodinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persitentStoreURL, options: options)
                } catch let error {
                    debugPrint("Error: create Presistent \(error)")
                }
                return persitentCoodinator
    }()
    
    private lazy var manageObjectContext: NSManagedObjectContext = {
        
        let manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        manageObjectContext.persistentStoreCoordinator = coordinator
        return manageObjectContext
    }()
    
    private func saveContext() -> Bool {
        if !manageObjectContext.hasChanges {
            return true
        }
        do {
            try manageObjectContext.save()
            return true
        } catch let error {
            debugPrint("Error: Save context: \(error)")
            manageObjectContext.rollback()
            return false
        }
    }
}

extension DatabaseManager {
    
    func addFavorite(id: Int) -> Bool {
        let entity = NSEntityDescription.insertNewObject(forEntityName: favoriteEntity, into: manageObjectContext) as! Favorite
        entity.id = Int64(id)
        return saveContext()
    }
    
    func getListFavorite() -> [Favorite] {
        let fetchRequest = Favorite.fetchRequest()
        do {
            return try manageObjectContext.fetch(fetchRequest)
        } catch let error {
            debugPrint("Error: get list favorite \(error)")
        }
        return []
    }
    
    func deleteFavorite(with id: Int) {
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let favorites = try manageObjectContext.fetch(fetchRequest)
            for favorite in favorites {
                try manageObjectContext.delete(favorite)
            }
        } catch let error {
            debugPrint("Error: delete contact \(error)")
        }
        _ = saveContext()
    }
    
    func checkFavorite(with id: Int) -> Bool {
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            if let favorite = try manageObjectContext.fetch(fetchRequest).first{
                return true
            }
        } catch let error {
            debugPrint("Error: delete contact \(error)")
        }
        
        return false
    }
}
