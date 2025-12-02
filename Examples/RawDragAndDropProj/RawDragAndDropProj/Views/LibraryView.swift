//
//  LibraryView.swift
//  RawDragAndDropProj
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var libraryVM = LibraryVM()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(libraryVM.bookList) { book in
                    NavigationLink(destination: BookDetailView(book: book)) {
                        LibraryBookRow(book: book)
                    }
                }
                .onDelete(perform: libraryVM.deleteBook)
                .onMove(perform: libraryVM.moveBooks)
            }
            .listStyle(.plain)
            .navigationTitle("Всі книги")
            .toolbar {
                Button {
                    libraryVM.isShowingSearch = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $libraryVM.isShowingSearch) {
                BookSearchView()
                    .onDisappear {
                        libraryVM.fetchBooks()
                    }
            }
            .onAppear {
                libraryVM.fetchBooks()
            }
        }
    }
}
