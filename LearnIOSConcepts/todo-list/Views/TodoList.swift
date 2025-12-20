import SwiftUI

struct TodoList: View {
    @StateObject var viewModel: TodoListViewModel
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
    return TodoList(viewModel: TodoListViewModel())
        .environment(\.managedObjectContext, context)
}
