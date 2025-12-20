import SwiftUI

struct IndexSetMap: Identifiable {
    let id = UUID().uuidString
    var indices: IndexSet
}

struct TaskList: View {
    @StateObject var viewModel: TaskListViewModel
    @State private var showAddTask = false
    @State private var indicesToDelete: IndexSetMap?

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
                            ForEach(viewModel.tasks.sorted()) {
                                TaskListRow(task: $0)
                            }
                            .onDelete { indicesToDelete = .init(indices: $0) }
                        }
                        .animation(.default, value: viewModel.tasks)
                    }
                }
            }
            .alert(item: $indicesToDelete) {
                makeDeletionAlert(indices: $0)
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

    // MARK: Helpers

    func makeDeletionAlert(indices: IndexSetMap) -> Alert {
        return Alert(title: Text("Are you sure you wanna delete this task?"),
                     primaryButton: .destructive(Text("Delete"), action: {
                         withAnimation { viewModel.onDelete(indexSet: indices.indices) }
                     }),
                     secondaryButton: .cancel { indicesToDelete = nil })
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let repo = TaskListRepo(context: context)
    return TaskList(viewModel: TaskListViewModel(repo: repo))
        .environment(\.managedObjectContext, context)
}
