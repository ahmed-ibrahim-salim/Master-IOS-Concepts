import CoreData

class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    private let repo: TaskListRepo

    init(repo: TaskListRepo) {
        self.repo = repo
        self.repo.onPerformFetch = { [weak self] tasks in
            guard let self = self else { return }
            self.tasks = tasks
        }

        self.repo.initialFetch()
    }
    
    func onDelete(indexSet: IndexSet) {
        repo.onDelete(indexSet: indexSet)
    }
}
