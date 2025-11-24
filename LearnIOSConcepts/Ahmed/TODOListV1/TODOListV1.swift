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

struct TODOListV1: View {
    var tasks = [Task(title: "Task 1"), Task(title: "Task 2")]
    var body: some View {
        VStack {
            Text("TODOLIST V1")

            List(tasks) {
                Text($0.title)
            }

        }
    }
}

#Preview {
    TODOListV1()
}
