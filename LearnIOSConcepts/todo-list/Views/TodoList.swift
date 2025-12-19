import SwiftUI

struct TodoList: View {
    @StateObject var viewModel: TodoListViewModel
    // Sort by time
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    var tasks: FetchedResults<TaskItem>
    @State private var showAddTask = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if tasks.isEmpty {
                        VStack {
                            Text("No tasks added yet")
                        }
                    } else {
                        List(tasks.sorted()) {
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
