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
    private let recentEntity = "Recent"
    
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

// MARK: - Extension DatabaseManage
extension DatabaseManager {
    
    func addFavorite(idUser: String, id: Int, name: String, posterPath: String, time: Int, overview: String) -> Bool {
        let entity = NSEntityDescription.insertNewObject(forEntityName: favoriteEntity, into: manageObjectContext) as! Favorite
        entity.idUser = idUser
        entity.id = Int64(id)
        entity.name = name
        entity.posterPath = posterPath
        entity.time = Int64(time)
        entity.overview = overview
        return saveContext()
    }
    
    func getListFavorite(idUser: String) -> [Favorite] {
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idUser == %@", idUser)
        do {
            return try manageObjectContext.fetch(fetchRequest)
        } catch let error {
            debugPrint("Error: get list favorite \(error)")
        }
        return []
    }
    
    func deleteFavorite(with id: Int, of idUser: String) {
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d AND idUser == %@",id, idUser)
        do {
            let favorites = try manageObjectContext.fetch(fetchRequest)
            for favorite in favorites {
                manageObjectContext.delete(favorite)
            }
        } catch let error {
            debugPrint("Error: delete contact \(error)")
        }
        _ = saveContext()
    }
    
    func checkFavorite(with id: Int, of idUser: String) -> Bool {
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d AND idUser == %@",id, idUser)
        do {
            if let favorite = try manageObjectContext.fetch(fetchRequest).first{
                return true
            }
        } catch let error {
            debugPrint("Error: delete contact \(error)")
        }
        
        return false
    }
    
    func addRecent(idUser: String, id: Int, name: String, posterPath: String, time: Int, overview: String) -> Bool {
        let entity = NSEntityDescription.insertNewObject(forEntityName: recentEntity, into: manageObjectContext) as! Recent
        entity.idUser = idUser
        entity.id = Int64(id)
        entity.name = name
        entity.posterPath = posterPath
        entity.time = Int64(time)
        entity.overview = overview
        return saveContext()
    }
    
    func getListRecent(idUser: String) -> [Recent] {
        let fetchRequest = Recent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idUser == %@", idUser)
        do {
            return try manageObjectContext.fetch(fetchRequest)
        } catch let error {
            debugPrint("Error: get list recent \(error)")
        }
        return []
    }
    
    func checkRecent(with id: Int, idUser: String) -> Bool {
        let fetchRequest = Recent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d AND idUser == %@", id, idUser)
        do {
            if let recent = try manageObjectContext.fetch(fetchRequest).first{
                return true
            }
        } catch let error {
            debugPrint("Error: delete contact \(error)")
        }
        
        return false
    }
    
    func deleteRecent(with id: Int, idUser: String) {
        let fetchRequest = Recent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d AND idUser == %@", id, idUser)
        do {
            let recents = try manageObjectContext.fetch(fetchRequest)
            for recent in recents {
                manageObjectContext.delete(recent)
            }
        } catch let error {
            debugPrint("Error: delete contact \(error)")
        }
        
        _ = saveContext()
    }
}
