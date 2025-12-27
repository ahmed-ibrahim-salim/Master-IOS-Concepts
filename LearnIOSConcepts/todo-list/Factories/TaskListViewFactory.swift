//
//  View.swift
//  LearnIOSConcepts
//
//  Created by Ahmed Ibrahim on 27/12/2025.
//

import CoreData
import Foundation

@MainActor
class TaskListViewFactory {
    static func makeTaskListView(context: NSManagedObjectContext) -> TaskList {
        let localDataSource = TaskListLocalDataSource(context: context)
        let remoteDataSource = TaskListRemoteDataSource()

        let vm = TaskListViewModel(repo: TaskListRepo(localDataSource: localDataSource, remoteDataSource: remoteDataSource))
        return TaskList(viewModel: vm)
    }
}
