import SwiftUI

struct ContentView: View {
    var body: some View {
        TaskListViewFactory.makeTaskListView(context:PersistenceController.shared.container.viewContext)
    }
}

#Preview {
    ContentView()
}
