import SwiftUI

struct TaskListRow: View {
    var task: TaskItem
    @State var showMarkAsCompleted = false
    var onMarkAsCompleted: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .bold()
                    .strikethrough(task.completed)
                HStack {
                    Text("At")
                    Text(task.wrappedTime, style: .time)
                }
                .foregroundStyle(.blue)
                
                if !task.taskDescription.isEmpty {
                    Text(task.taskDescription)
                }
            }

            Spacer()
            Button {
                showMarkAsCompleted.toggle()
            } label: {
                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 28))
            }
        }
        .alert("Are you sure you wanna mark this as completed?", isPresented: $showMarkAsCompleted) {
            Button("OK") {
                onMarkAsCompleted()
            }

            Button("Cancel") {
                showMarkAsCompleted.toggle()
            }
        }
    }
}
