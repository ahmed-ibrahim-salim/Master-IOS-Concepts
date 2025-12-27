import CoreData

protocol FetchableDataSource {
    var onUpdate: (([TaskItem]) -> Void)? { get set }
    
    func fetchTasks() throws -> [TaskItem]

    func onDelete(taskItem: TaskItem) async throws

    func onMarkAsCompleted(taskItem: TaskItem) async throws
}

class TaskListRemoteDataSource: FetchableDataSource {
    
    var onUpdate: (([TaskItem]) -> Void)?
    
    func fetchTasks() -> [TaskItem] {
        return []
    }
    
    func onDelete(taskItem: TaskItem) throws {}
    
    func onMarkAsCompleted(taskItem: TaskItem) throws {}
    
}

class TaskListLocalDataSource: NSObject, FetchableDataSource {
    private let context: NSManagedObjectContext
    private let frc: NSFetchedResultsController<TaskItem>
    private var isInitial = true
    var onUpdate: (([TaskItem]) -> Void)?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request = TaskItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskItem.time, ascending: false)]
        
        self.frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        frc.delegate = self
    }
    
    func fetchTasks() throws -> [TaskItem] {
        if isInitial {
            let data = try initialFetch()
            isInitial = false
            return data
        }
        
        return []
    }
    
    private func initialFetch() throws -> [TaskItem] {
        do {
            try frc.performFetch()
            return frc.fetchedObjects ?? []
        } catch {
            throw error
        }
    }
    
    func onDelete(taskItem: TaskItem) throws {
        try context.performAndWait {
            context.delete(taskItem)
            try context.save()
        }
    }

    func onMarkAsCompleted(taskItem: TaskItem) throws {
        try context.performAndWait {
            taskItem.completed = true
            try context.save()
        }
    }
}

extension TaskListLocalDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        if let fetchedTasks = controller.fetchedObjects as? [TaskItem] {
            onUpdate?(fetchedTasks)
        }
    }
}
