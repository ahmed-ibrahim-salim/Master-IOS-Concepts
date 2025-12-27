import SwiftUI

@MainActor
class AddOrEditTaskViewModel: ObservableObject {
    private let viewContext = PersistenceController.shared.container.viewContext
    @Published var taskObject: TaskStateObject
    private(set) var taskItemToEdit: TaskItem?
    private var repo: AddOrEditTaskRepoProtocol

    init(taskItemToEdit: TaskItem?, repo: AddOrEditTaskRepoProtocol) {
        self.taskItemToEdit = taskItemToEdit
        self.repo = repo

        // Early exit
        guard let item = taskItemToEdit else {
            taskObject = TaskStateObject()
            return
        }

        taskObject = TaskStateObject(
            title: item.title,
            taskDesc: item.taskDescription,
            dueDate: item.wrappedTime
        )
    }

    func save(onSuccess: @escaping () -> Void) async {
        do {
            try await repo.save(taskItemToEdit: taskItemToEdit, taskObject: taskObject)

            // if user clicked save and then dismissed the view immediatly, this task(closure) will keep a strong reference of the viewModel.
            guard !Task.isCancelled else { return }

            onSuccess()
        } catch {
            let nsError = error as NSError
            // TODO: show the error
        }
    }
}
