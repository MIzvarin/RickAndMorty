//
//  StorageManager.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 11.09.2021.
//
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var context = persistentContainer.viewContext
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func remove(character: FavoriteCharacters) {
        context.delete(character)
        saveContext()
    }
    
    func fetchFavotiteCharacters() -> [FavoriteCharacters] {
        var favoriteCharacters: [FavoriteCharacters] = []
        let fetchRequest: NSFetchRequest<FavoriteCharacters> = FavoriteCharacters.fetchRequest()
        do {
            favoriteCharacters = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return favoriteCharacters
    }
    
    func fetchCharacterByURL(url: String) -> FavoriteCharacters?{
        var characters: [FavoriteCharacters]?
        let fetchRequest: NSFetchRequest<FavoriteCharacters> = FavoriteCharacters.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        do {
            characters = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error{
            print(error.localizedDescription)
        }
        guard let characters = characters else { return nil }
        return characters.first
    }
    
    func removeCharacter (character: FavoriteCharacters) {
        context.delete(character)
        saveContext()
    }
    
    func removeAllObjects() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteCharacters")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            saveContext()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    private init() {}
}
