import CoreData

class TaskListRepo: NSObject {
    private let context: NSManagedObjectContext
    private let frc: NSFetchedResultsController<TaskItem>
    
    var onPerformFetch: (([TaskItem]) -> Void)?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request = TaskItem.fetchRequest()
        request.sortDescriptors = []
        
        self.frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        frc.delegate = self
    }
    
    func initialFetch() {
        do {
            try frc.performFetch()
            onPerformFetch?(frc.fetchedObjects ?? [])
        } catch {
            print("Failed to fetch tasks \(error)")
        }
    }
    
    func onDelete(taskItem: TaskItem) {
        context.delete(taskItem)
        PersistenceController.shared.save()
    }
}

extension TaskListRepo: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        if let fetchedTask = controller.fetchedObjects as? [TaskItem] {
            onPerformFetch?(fetchedTask)
        }
    }
}
