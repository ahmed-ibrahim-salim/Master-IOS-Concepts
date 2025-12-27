import SwiftUI

enum TastSheetDestination: Identifiable {
    case add
    case edit(TaskItem)

    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let taskItem):
            return taskItem.objectID.uriRepresentation().absoluteString
        }
    }
}

struct TaskList: View {
    @StateObject var viewModel: TaskListViewModel

    @State private var taskItemToDelete: TaskItem?
    @State private var isDeleting: Bool = false

    @State private var sheetDestination: TastSheetDestination?

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
                                TaskListRow(task: taskItem) {
                                    viewModel.onMarkAsCompleted(taskItem: taskItem)
                                }
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
                                        sheetDestination = .edit(taskItem)
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
            .task {
                await viewModel.getTasksStream()
            }
            .alert("Are you sure you wanna delete this task?", isPresented: $isDeleting, presenting: taskItemToDelete) { taskItem in
                Button(role: .destructive) {
                    withAnimation { viewModel.onDelete(taskItem: taskItem) }
                } label: {
                    Text("Delete")
                }
            }
            .sheet(item: $sheetDestination, onDismiss: { sheetDestination = nil }) { sheetDestination in
                switch sheetDestination {
                case .add:
                    AddOrEditViewFactory.makeAddOrEditView(taskItemToEdit: nil, context: PersistenceController.shared.container.viewContext)
                case .edit(let item):
                    AddOrEditViewFactory.makeAddOrEditView(taskItemToEdit: item, context: PersistenceController.shared.container.viewContext)
                }
            }
            .navigationTitle("Your tasks")
            .toolbar {
                Button("Add Task") {
                    sheetDestination = .add
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return TaskListViewFactory.makeTaskListView(context: context)
        .environment(\.managedObjectContext, context)
}
