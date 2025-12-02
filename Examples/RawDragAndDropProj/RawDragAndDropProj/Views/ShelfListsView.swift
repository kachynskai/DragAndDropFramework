//
//  ArchiveListsView.swift
//  RawDragAndDropProj
//

import SwiftUI

struct ShelfListsView: View {
    @StateObject private var shelfVM = ShelfVM()
    @State private var draggedBook: Book?
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        ShelfSectionView( title: "Читаю зараз", books: $shelfVM.readingBooks, color: .blue,
                                          draggedBook: $draggedBook, listId: "reading", viewModel: shelfVM)
                        
                        ShelfSectionView(title: "Прочитано", books: $shelfVM.finishedBooks, color: .green,
                                         draggedBook: $draggedBook, listId: "finished", viewModel: shelfVM)
                    }
                    .padding()
                }
            }
            .navigationTitle("Прогрес")
            .onAppear {
                shelfVM.fetchData()
            }
        }
    }
}
