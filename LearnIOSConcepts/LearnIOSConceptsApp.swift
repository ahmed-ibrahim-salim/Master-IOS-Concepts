//
//  LearnIOSConceptsApp.swift
//  LearnIOSConcepts
//
//  Created by Ahmed Ibrahim on 02/08/2025.
//

import SwiftUI

@main
struct LearnIOSConceptsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


