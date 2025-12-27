//
//  AddOrEditViewFactory.swift
//  LearnIOSConcepts
//
//  Created by Ahmed Ibrahim on 23/12/2025.
//

import CoreData
import Foundation

@MainActor
class AddOrEditViewFactory {
    
    static func makeAddOrEditView(taskItemToEdit: TaskItem?, context: NSManagedObjectContext) -> AddOrEditTaskView {
        let localDataSource = LocalDataSource(context: context)
        let remoteDataSource = RemoteDataSource()
        
        let vm = AddOrEditTaskViewModel(taskItemToEdit: taskItemToEdit,
                                      repo: AddOrEditTaskRepo(localDataSource: localDataSource, remoteDataSource: remoteDataSource))
        return AddOrEditTaskView(viewModel: vm)
    }
}
