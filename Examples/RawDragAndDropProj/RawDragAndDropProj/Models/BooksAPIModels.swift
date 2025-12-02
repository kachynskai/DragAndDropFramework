//
//  Note.swift
//  RawDragAndDropProj
//

import Foundation

struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]?
}

struct GoogleBookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let pageCount: Int?
    let imageLinks: ImageLinks?
    
    var authorsList: String {
        authors?.joined(separator: ", ") ?? "Unknown author"
    }
    
    var imageURL: String {
        let temp = imageLinks?.thumbnail ?? imageLinks?.smallThumbnail ?? ""
        return temp.replacingOccurrences(of: "http://", with: "https://")
    }
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}
