//
//  LearnIOSConcepts
//
//  Created by Ahmed Ibrahim on 24/11/2025.
//

import MapKit
import SwiftUI

struct TodoList: View {
    // Sort by time
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.time, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<TaskItem>

    @State private var showAddTask = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if tasks.isEmpty {
                        VStack {
                            Text("No tasks added yet")
                        }
                    } else {
                        List(tasks) {
                            Text($0.title)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskView()
            }
            .navigationTitle("Your tasks")
            .toolbar {
                Button("Add Task") {
                    showAddTask.toggle()
                }
            }
        }
    }
}
