import CoreData
import SwiftUI

class TodoListViewModel: NSObject, ObservableObject {
    @Published var tasks: [TaskItem] = []
    
    private let context = PersistenceController.shared.container.viewContext
    private let frc: NSFetchedResultsController<TaskItem>
    
    override init() {
        let request = TaskItem.fetchRequest()
        request.sortDescriptors = []
        
        self.frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        frc.delegate = self
        
        do {
           try frc.performFetch()
            tasks = frc.fetchedObjects ?? []
        } catch {
            print("Failed to fetch tasks \(error)")
        }
    }
}

extension TodoListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        if let fetchedTask = controller.fetchedObjects as? [TaskItem] {
            tasks = fetchedTask
        }
    }
}
