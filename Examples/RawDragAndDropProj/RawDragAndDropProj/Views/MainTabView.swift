//
//  TabView.swift
//  RawDragAndDropProj
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Бібліотека", systemImage: "books.vertical")
                }
            ShelfListsView()
                .tabItem {
                    Label("Моя поличка", systemImage: "chart.bar.doc.horizontal")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
