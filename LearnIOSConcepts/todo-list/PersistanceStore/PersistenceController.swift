//
//  PersistenceController.swift
//  LearnIOSConcepts
//
//  Created by Ahmed Ibrahim on 18/12/2025.
//

import CoreData

struct PersistenceController {
    // 1. Singleton instance for the whole app
    static let shared = PersistenceController()

    // 2. Storage for Core Data
    let container: NSPersistentContainer

    // 3. Initialization
    init() {
        // Must match the name of your .xcdatamodeld file
        container = NSPersistentContainer(name: "MainStore")

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for error:
                 - The parent directory does not exist or cannot be created.
                 - The store is not accessible (permissions/lock).
                 - Device is out of space.
                 - The model has changed without a migration (Heavyweight vs Lightweight).
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // 5. Convenience Save Method
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError)")
            }
        }
    }
}
