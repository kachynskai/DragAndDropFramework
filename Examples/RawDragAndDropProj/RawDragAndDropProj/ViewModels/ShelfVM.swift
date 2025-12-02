//
//  ShelfVM.swift
//  RawDragAndDropProj
//

import Combine

final class ShelfVM: ObservableObject {
    @Published var readingBooks: [Book] = []
    @Published var finishedBooks: [Book] = []
    
    func fetchData() {
        self.readingBooks = StorageService.shared.fetchBooks(by: .reading)
        self.finishedBooks = StorageService.shared.fetchBooks(by: .finished)
    }
    
    func moveBook(book: Book, toTargetListID listID: String) {
        let targetStatus: BookStatus = (listID == "reading") ? .reading : .finished
        guard book.readingStatus != targetStatus else { return }
        
        if book.readingStatus == .reading {
            readingBooks.removeAll { $0 == book }
        } else {
            finishedBooks.removeAll { $0 == book }
        }
        
        book.readingStatus = targetStatus
        
        if targetStatus == .reading {
            readingBooks.insert(book, at: 0)
        } else {
            finishedBooks.insert(book, at: 0)
        }
        saveReorderedList()
    }
    
    func saveReorderedList() {
        for (index, book) in readingBooks.enumerated() {
            book.sortIndex = Int64(index)
        }
        
        for (index, book) in finishedBooks.enumerated() {
            book.sortIndex = Int64(index)
        }
        StorageService.shared.saveData()
    }
    
}
