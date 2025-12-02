//
//  BookSearchVM.swift
//  RawDragAndDropProj
//

import Foundation
import Combine

final class BookSearchVM: ObservableObject {
    @Published var searchText: String = ""
    @Published var books: [GoogleBookItem] = []
    @Published var isLoading: Bool = false
    @Published var wasSeach: Bool = false
    
    func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isLoading = true
        wasSeach = true
        books = []
        Task {
            do {
                let fetchedBooks = try await BooksAPIService.shared.searchBooks(query: searchText)
                self.books = fetchedBooks.filter { ($0.volumeInfo.pageCount ?? 0) > 0 }
                print("Success! Found \(fetchedBooks.count) books.")
            } catch {
                print("Error in VM: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }
    
    func addBook(_ googleBook: GoogleBookItem) {
        StorageService.shared.addBook(from: googleBook)
    }
    
}
