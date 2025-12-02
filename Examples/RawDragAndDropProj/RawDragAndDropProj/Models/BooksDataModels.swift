//
//  BooksDataModels.swift
//  RawDragAndDropProj
//

import SwiftUI

enum BookStatus: String, CaseIterable {
    case wantToRead
    case reading
    case finished
    
    var title: String {
        switch self {
        case .wantToRead: return "Хочу прочитати"
        case .reading: return "Читаю"
        case .finished: return "Прочитано"
        }
    }

    var color: Color {
        switch self {
        case .wantToRead: return .gray
        case .reading: return .blue
        case .finished: return .green
        }
    }
}

extension Book {
    var readingStatus: BookStatus {
        get {
            return BookStatus(rawValue: self.status ?? "") ?? .wantToRead
        }
        set {
            self.status = newValue.rawValue
        }
    }
    
    var progressValue: Double {
        let value = Double(currentPage) / Double(pageCount)
        return min(max(value, 0.0), 1.0)
    }
    
    var progressString: String {
        let percent = Int(progressValue * 100)
        return "\(percent)%"
    }
}
