import CoreData

protocol TaskListRepoProtocol {
    func taskStream() -> AsyncStream<[TaskItem]>
    func onDelete(taskItem: TaskItem) async throws
    func onMarkAsCompleted(taskItem: TaskItem) async throws
}

final class TaskListRepo: TaskListRepoProtocol {
    private var continuation: AsyncStream<[TaskItem]>.Continuation?
    private var localDataSource: FetchableDataSource
    private var remoteDataSource: FetchableDataSource

    init(localDataSource: FetchableDataSource, remoteDataSource: FetchableDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func taskStream() -> AsyncStream<[TaskItem]> {
        stopUpdates()

        return AsyncStream { continuation in
            // Save the continuation
            self.continuation = continuation
            
            self.localDataSource.onUpdate = { [weak self] tasks in
                self?.continuation?.yield(tasks)
            }
            
            do {
                try fetchTasks()
            } catch {
                continuation.finish()
            }

            // Handle Cleanup
            continuation.onTermination = { @Sendable _ in
                self.stopUpdates()
            }
        }
    }

    private func fetchTasks() throws {
        do {
            let data = try localDataSource.fetchTasks()
            continuation?.yield(data)
        } catch {
            throw error
        }
    }

    private func stopUpdates() {
        continuation?.finish()
        continuation = nil
    }

    func onDelete(taskItem: TaskItem) async throws {
        do {
            try await localDataSource.onDelete(taskItem: taskItem)
        } catch {
            throw error
        }

        Task {
            do {
                try await remoteDataSource.onDelete(taskItem: taskItem)
            } catch {
                throw error
            }
        }
    }

    func onMarkAsCompleted(taskItem: TaskItem) async throws {
        do {
            try await localDataSource.onMarkAsCompleted(taskItem: taskItem)
        } catch {
            throw error
        }

        Task {
            do {
                try await remoteDataSource.onMarkAsCompleted(taskItem: taskItem)
            } catch {
                throw error
            }
        }
    }
}
