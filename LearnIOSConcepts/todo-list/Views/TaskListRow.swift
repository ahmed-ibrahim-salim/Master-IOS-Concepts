import SwiftUI

struct TaskListRow: View {
    @ObservedObject var task: TaskItem

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
                markTaskAsCompleted()
            } label: {
                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 28))
            }
        }
    }

    func markTaskAsCompleted() {
//    # TODO: add alert to prompt task completion.
        task.completed = true

        PersistenceController.shared.save()
    }
}
