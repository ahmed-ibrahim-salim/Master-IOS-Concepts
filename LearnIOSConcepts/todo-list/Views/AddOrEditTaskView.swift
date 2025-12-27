import SwiftUI

struct AddOrEditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddOrEditTaskViewModel

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Title", text: $viewModel.taskObject.title)
                ZStack(alignment: .topLeading) {
                    if viewModel.taskObject.taskDesc.isEmpty {
                        Text("Enter your message here...")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }

                    TextEditor(text: $viewModel.taskObject.taskDesc)
                        .foregroundColor(.primary)
                        .frame(minHeight: 100)
                }
                DatePicker("Due Time", selection: $viewModel.taskObject.dueDate, displayedComponents: [.date, .hourAndMinute])
            }
            .navigationTitle("Add Task")
            .toolbar {
                Button("Save") {
                    Task {
                        await viewModel.save {
                            dismiss()
                        }
                    }
                }
                .disabled(viewModel.taskObject.title.isEmpty)
            }
        }
    }
}
