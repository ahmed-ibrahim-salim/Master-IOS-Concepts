import SwiftUI

struct TaskListRow: View {
    @ObservedObject var task: TaskItem
    @State var showMarkAsCompleted = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.completed)
                HStack {
                    Text("At")
                    Text(task.wrappedTime, style: .time)
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
                markTaskAsCompleted()
            }

            Button("Cancel") {
                showMarkAsCompleted.toggle()
            }
        }
    }

    func markTaskAsCompleted() {
        task.completed = true

        PersistenceController.shared.save()
    }
}
