import CoreData

@MainActor
class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    private let repo: TaskListRepoProtocol

    init(repo: TaskListRepoProtocol) {
        self.repo = repo
    }

    func getTasksStream() async {
        for await updatedTasks in repo.taskStream() {
            tasks = updatedTasks
        }
    }

    func onDelete(taskItem: TaskItem) {
        Task {
            do {
                try await repo.onDelete(taskItem: taskItem)
            } catch {
                // TODO: Show error on the view
            }
        }
    }

    func onMarkAsCompleted(taskItem: TaskItem) {
        Task {
            do {
                try await repo.onMarkAsCompleted(taskItem: taskItem)
            } catch {
                // TODO: Show error on the view
            }
        }
    }
}
