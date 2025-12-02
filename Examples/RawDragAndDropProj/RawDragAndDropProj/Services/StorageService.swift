//
//  StorageService.swift
//  RawDragAndDropProj
//

internal import CoreData

final class StorageService {
    static let shared = StorageService()
    
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext { container.viewContext }
    
    private init() {
        self.container = PersistenceController.shared.container
    }
    
    func fetchAllBooks() -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(keyPath: \Book.libraryIndex, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching books: \(error)")
            return []
        }
    }
    
    func fetchBooks(by status: BookStatus) -> [Book] {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        
        request.predicate = NSPredicate(format: "status == %@", status.rawValue)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Book.sortIndex, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error with fetching books with status -- \(status): \(error)")
            return []
        }
    }
    
    func addBook(from googleBook: GoogleBookItem) {
        let newBook = Book(context: context)
        
        newBook.id = UUID()
        newBook.title = googleBook.volumeInfo.title
        newBook.desc = googleBook.volumeInfo.description ?? "No description"
        newBook.author = googleBook.volumeInfo.authorsList
        newBook.imageURL = googleBook.volumeInfo.imageURL
        newBook.pageCount = Int16(googleBook.volumeInfo.pageCount ?? 0)
        
        newBook.currentPage = 0
        newBook.readingStatus = .wantToRead
        
        newBook.sortIndex = Int64(0 - Date().timeIntervalSince1970)
        let currentMin = getMinLibraryIndex()
        newBook.libraryIndex = currentMin - 1
        saveData()
        
    }
    
    func updateStatus(for book: Book, newStatus: BookStatus) {
        switch (book.readingStatus, newStatus) {
        case (_, .finished):
            book.currentPage = book.pageCount
        case (.finished, .reading):
            break
        case (_, .wantToRead):
            book.currentPage = 0
        default:
            break
        }
        book.readingStatus = newStatus
        saveData()
    }
    
    func updateProgress(book: Book, newPage: Int) {
        book.currentPage = Int16(newPage)
        let neededStatus: BookStatus
        
        if newPage == 0 {
            neededStatus = .wantToRead
        } else if book.pageCount > 0 && newPage >= book.pageCount {
            neededStatus = .finished
        } else {
            neededStatus = .reading
        }
        
        if book.readingStatus != neededStatus {
            updateStatus(for: book, newStatus: neededStatus)
        }
        saveData()
    }
    
    func deleteBook(_ book: Book) {
        context.delete(book)
        saveData()
    }
    
    private func getMinLibraryIndex() -> Int64 {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Book.libraryIndex, ascending: true)]
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request).first
            return result?.libraryIndex ?? 0
        } catch {
            return 0
        }
    }

    func saveData() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error with saving in to database: \(error.localizedDescription)")
            }
        }
    }
    
}
