import SwiftUI

struct ContentView: View {
    var body: some View {
        TaskList(viewModel: TaskListViewModel(repo: TaskListRepo()))
    }
}

#Preview {
    ContentView()
}
