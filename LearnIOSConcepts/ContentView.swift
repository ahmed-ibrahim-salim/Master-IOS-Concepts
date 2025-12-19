import SwiftUI

struct ContentView: View {
    var body: some View {
        TodoList(viewModel: TodoListViewModel())
    }
}

#Preview {
    ContentView()
}
