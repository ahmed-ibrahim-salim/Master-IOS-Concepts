import SwiftUI

struct AddOrEditTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var taskObject: TaskStateObject

    var taskItemToEdit: TaskItem?

    init(taskItemToEdit: TaskItem?) {
        self.taskItemToEdit = taskItemToEdit

        if let item = taskItemToEdit {
            let initialData = TaskStateObject(
                title: item.title,
                taskDesc: item.taskDescription,
                dueDate: item.wrappedTime
            )
            _taskObject = State(initialValue: initialData)
        } else {
            _taskObject = State(initialValue: .init())
        }
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Title", text: $taskObject.title)
                ZStack(alignment: .topLeading) {
                    if taskObject.taskDesc.isEmpty {
                        Text("Enter your message here...")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }

                    TextEditor(text: $taskObject.taskDesc)
                        .foregroundColor(.primary)
                        .frame(minHeight: 100)
                }
                DatePicker("Due Time", selection: $taskObject.dueDate, displayedComponents: [.date, .hourAndMinute])
            }
            .navigationTitle("Add Task")
            .toolbar {
                Button("Save") {
                    save()
                }
                .disabled(taskObject.title.isEmpty)
            }
        }
    }

    func save() {
        let itemToSave = taskItemToEdit ?? TaskItem(context: viewContext)

        itemToSave.title = taskObject.title
        itemToSave.taskDescription = taskObject.taskDesc
        itemToSave.time = taskObject.dueDate

        PersistenceController.shared.save()
        dismiss()
    }
}
