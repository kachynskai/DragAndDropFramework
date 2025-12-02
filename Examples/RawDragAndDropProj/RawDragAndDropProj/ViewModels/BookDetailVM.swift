//
//  BookDetailVM.swift
//  RawDragAndDropProj
//
import Combine

final class BookDetailVM: ObservableObject {
    let book: Book
    @Published var curPage: Double
    
    init(book: Book) {
        self.book = book
        self.curPage = Double(book.currentPage)
    }
    var pageProgressText: String {
        "\(Int(curPage)) / \(book.pageCount)"
    }
    
    var percentageText: String {
        guard book.pageCount > 0 else { return "0%" }
        let percent = Int((curPage / Double(book.pageCount)) * 100)
        return "\(percent)%"
    }
    
    func saveProgress() {
        StorageService.shared.updateProgress(book: book, newPage: Int(curPage))
        self.curPage = Double(book.currentPage)
    }
    
}
