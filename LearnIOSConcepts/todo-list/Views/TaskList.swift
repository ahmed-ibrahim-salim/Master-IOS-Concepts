import SwiftUI

struct TaskList: View {
    @StateObject var viewModel: TaskListViewModel
    @State private var showAddTask = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if viewModel.tasks.isEmpty {
                        VStack {
                            Text("No tasks added yet")
                        }
                    } else {
                        List(viewModel.tasks.sorted()) {
                            TaskListRow(task: $0)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskView()
            }
            .navigationTitle("Your tasks")
            .toolbar {
                Button("Add Task") {
                    showAddTask.toggle()
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
