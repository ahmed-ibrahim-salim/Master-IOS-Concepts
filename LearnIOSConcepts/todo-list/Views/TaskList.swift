import SwiftUI

struct TaskList: View {
    @StateObject var viewModel: TaskListViewModel
    
    @State private var taskItemToDelete: TaskItem?
    @State private var isDeleting: Bool = false
    
    @State private var isAddingOrEditingTask = false
    @State private var taskToEdit: TaskItem?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if viewModel.tasks.isEmpty {
                        VStack {
                            Text("No tasks added yet")
                        }
                    } else {
                        List {
                            ForEach(viewModel.tasks) { taskItem in
                                TaskListRow(task: taskItem)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            self.taskItemToDelete = taskItem
                                            isDeleting.toggle()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button {
                                            taskToEdit = taskItem
                                            isAddingOrEditingTask.toggle()
                                        } label: {
                                            Label("Edit", systemImage: "square.and.pencil")
                                        }
                                        .tint(.orange)
                                    }
                            }
                        }
                        .animation(.default, value: viewModel.tasks)
                    }
                }
            }
            .alert("Are you sure you wanna delete this task?", isPresented: $isDeleting, presenting: taskItemToDelete) { taskItem in
                Button(role: .destructive) {
                    withAnimation { viewModel.onDelete(taskItem: taskItem) }
                } label: {
                    Text("Delete")
                }
            }
            .sheet(isPresented: $isAddingOrEditingTask, onDismiss: {taskToEdit = nil}) {
                AddOrEditTaskView(taskItemToEdit: taskToEdit)
            }
            .navigationTitle("Your tasks")
            .toolbar {
                Button("Add Task") {
                    isAddingOrEditingTask.toggle()
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let repo = TaskListRepo(context: context)
    return TaskList(viewModel: TaskListViewModel(repo: repo))
        .environment(\.managedObjectContext, context)
}
