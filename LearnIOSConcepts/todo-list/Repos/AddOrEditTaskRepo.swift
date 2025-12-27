import SwiftUI

protocol AddOrEditTaskRepoProtocol {
    func save(taskItemToEdit: TaskItem?, taskObject: TaskStateObject) async throws
}

class AddOrEditTaskRepo: AddOrEditTaskRepoProtocol {
    private let localDataSource: SaveableDataSource
    private let remoteDataSource: SaveableDataSource

    init(localDataSource: SaveableDataSource, remoteDataSource: SaveableDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func save(taskItemToEdit: TaskItem?, taskObject: TaskStateObject) async throws {
        do {
            try await localDataSource.save(taskItemToEdit: taskItemToEdit, taskObject: taskObject)
        } catch {
            throw error
        }

        Task {
            do {
                try await remoteDataSource.save(taskItemToEdit: taskItemToEdit, taskObject: taskObject)
            } catch {
                throw error
            }
        }
    }
}
