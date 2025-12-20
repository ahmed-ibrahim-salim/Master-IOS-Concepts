import CoreData

struct PersistenceController {
    // 1. Singleton instance for the whole app
    static let shared = PersistenceController()

    // 2. Storage for Core Data
    let container: NSPersistentContainer

    // 3. Initialization
    init(inMemory: Bool = false) {
        // Must match the name of your .xcdatamodeld file
        container = NSPersistentContainer(name: "MainStore")

        // For Previews
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
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

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true) // RAM-only store
        let viewContext = result.container.viewContext

        // Create a few sample tasks so the preview isn't empty
        let sampleTask = TaskItem(context: viewContext)
        sampleTask.title = "Buy Groceries"
        sampleTask.taskDescription = "Go to the nearest supermarket to buy tomatos & cumcumber"
        sampleTask.time = Date()
        sampleTask.completed = false

        let completedTask = TaskItem(context: viewContext)
        completedTask.title = "Gym Session"
        completedTask.time = Date().addingTimeInterval(-3600)
        completedTask.completed = true

        return result
    }()
}
