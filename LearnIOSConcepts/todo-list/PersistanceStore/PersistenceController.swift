import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Must match the name of your .xcdatamodeld file
        container = NSPersistentContainer(name: "MainStore")

        // For Previews
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        self.container.viewContext.automaticallyMergesChangesFromParent = true

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

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
