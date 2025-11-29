//
//  LearnIOSConcepts
//
//  Created by Ahmed Ibrahim on 24/11/2025.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID().uuidString
    let title: String
    let description: String? = nil
}

class TODOListViewModel: ObservableObject {
    var tasks = [Task(title: "Task 1"), Task(title: "Task 2")]
}

struct TODOList: View {
    @StateObject var viewModel: TODOListViewModel
    
    var body: some View {
        VStack {
            Text("TODOLIST V1")

            List($viewModel.tasks) {
                Text($0.title)
            }

        }
    }
}

#Preview {
    TODOList(viewModel: TODOListViewModel())
}
