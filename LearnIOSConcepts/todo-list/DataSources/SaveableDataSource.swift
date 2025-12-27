import CoreData
import SwiftUI

protocol SaveableDataSource {
    func save(taskItemToEdit: TaskItem?, taskObject: TaskStateObject) async throws
}

class RemoteDataSource: SaveableDataSource {
    func save(taskItemToEdit: TaskItem?, taskObject: TaskStateObject) async throws {
        // Mock API call
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//        }
    }
}

class LocalDataSource: SaveableDataSource {
    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func save(taskItemToEdit: TaskItem?, taskObject: TaskStateObject) async throws {
        let itemToSave = taskItemToEdit ?? TaskItem(context: viewContext)

        itemToSave.title = taskObject.title
        itemToSave.taskDescription = taskObject.taskDesc
        itemToSave.time = taskObject.dueDate

        try PersistenceController.shared.save()
    }
}
