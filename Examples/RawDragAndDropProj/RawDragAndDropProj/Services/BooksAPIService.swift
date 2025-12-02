//
//  BookAPIService.swift
//  RawDragAndDropProj
//

import Foundation
final class BooksAPIService {
    static let shared = BooksAPIService()
    
    private init() {}
    
    func searchBooks(query: String) async throws -> [GoogleBookItem] {
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)&langRestrict=uk&maxResults=20")
        else {
            print("Invalid url")
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decodedData = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
            return decodedData.items ?? []
        } catch {
            print("error with decoding: \(error)")
            return []
        }
    }
}
