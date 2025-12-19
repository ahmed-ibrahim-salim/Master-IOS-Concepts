import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State var title = ""
    @State var taskDesc = ""
    @State private var dueDate: Date = .init()

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Title", text: $title)
                ZStack(alignment: .topLeading) {
                    if taskDesc.isEmpty {
                        Text("Enter your message here...")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }

                    TextEditor(text: $taskDesc)
                        .foregroundColor(.primary)
                        .frame(minHeight: 100)
                }
                DatePicker("Due Time", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
            }
            .navigationTitle("Add Task")
            .toolbar {
                Button("Save") {
                    addTask()
                }
                .disabled(title.isEmpty)
            }
        }
    }

    func addTask() {
        let newTask = TaskItem(context: viewContext)

        newTask.title = title
        newTask.taskDescription = taskDesc
        newTask.time = dueDate
        PersistenceController.shared.save()

        dismiss()
    }
}

#Preview {
    AddTaskView()
}
