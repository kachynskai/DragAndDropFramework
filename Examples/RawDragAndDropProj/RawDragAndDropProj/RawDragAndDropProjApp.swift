//
//  RawDragAndDropProjApp.swift
//  RawDragAndDropProj
//

import SwiftUI
internal import CoreData

@main
struct RawDragAndDropProjApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
//            NotesListView()
//            BookSearchView()
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
