//
//  LibraryVM.swift
//  RawDragAndDropProj
//

import Combine
import Foundation
import SwiftUI

final class LibraryVM: ObservableObject {
    @Published var bookList: [Book] = []
    @Published var isShowingSearch = false
    
    func fetchBooks() {
        self.bookList = StorageService.shared.fetchAllBooks()
    }
    
    func deleteBook(at offsets: IndexSet) {
        offsets.map { bookList[$0] }.forEach { book in
            StorageService.shared.deleteBook(book)
        }
        fetchBooks()
    }
    
    func moveBooks(from source: IndexSet, to destination: Int) {
        bookList.move(fromOffsets: source, toOffset: destination)
        
        for (index, book) in bookList.enumerated() {
            book.libraryIndex = Int64(index)
        }
        
        StorageService.shared.saveData()
    }
    
    func saveReorderedList() {
        for (index, book) in bookList.enumerated() {
            book.libraryIndex = Int64(index)
        }
        StorageService.shared.saveData()
    }
}
