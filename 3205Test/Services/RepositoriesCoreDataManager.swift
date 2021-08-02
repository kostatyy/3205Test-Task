//
//  RepositoriesCoreDataManager.swift
//  3205Test
//
//  Created by Macbook Pro on 02.08.2021.
//

import CoreData
import UIKit

//MARK: - Repositpries Core Data Manager
final class RepositoriesCoreDataManager {
    
    static var shared = RepositoriesCoreDataManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RepositoriesList")
        container.loadPersistentStores { (_, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
        return container
    }()
    
    var moc: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    //MARK: - Get Saved Repository
    func getRepository(id: NSManagedObjectID) -> Repository? {
        do {
            return try moc.existingObject(with: id) as? Repository
        } catch {
            return nil
        }
    }
    
    // MARK: - Save Repository To CoreData
    func saveRepository(repositoryInfo: RepositoryItem) {
        let newRepo = Repository(context: moc)
        newRepo.setValue(repositoryInfo.name, forKey: "name")
        newRepo.setValue(repositoryInfo.owner.login, forKey: "ownerName")
        newRepo.setValue(repositoryInfo.created_at.formatDate(), forKey: "createdAt")
        
        if let repoDescr = repositoryInfo.description {
            newRepo.setValue(repoDescr, forKey: "descr")
        }
        do {
            try moc.save()
        } catch {
            return
        }
    }
    
    //MARK: - Get List Of Saved Repositories
    func fetchRepositories() -> [Repository] {
        do {
            let fetchRequest = NSFetchRequest<Repository>(entityName: "Repository")
            let repositories = try moc.fetch(fetchRequest)
            return repositories
        } catch {
            return []
        }
    }
    
    //MARK: - Delete Repository
    func deleteRepository(id: NSManagedObjectID) {
        do {
            let deletingRepository = try moc.existingObject(with: id) as! Repository
            moc.delete(deletingRepository)
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
