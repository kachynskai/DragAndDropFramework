//
//  LibraryBookRow.swift
//  RawDragAndDropProj
//

import SwiftUI

struct LibraryBookRow: View {
    @ObservedObject var book: Book
    
    var body: some View {
        HStack(spacing: 12) {
            if let urlStr = book.imageURL, let url = URL(string: urlStr) {
                AsyncImage(url: url) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.1)
                }
                .frame(width: 50, height: 75)
                .cornerRadius(6)
                .clipped()
            } else {
                ZStack {
                    Color.gray.opacity(0.1)
                    Image(systemName: "book.closed")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                .frame(width: 50, height: 75)
                .cornerRadius(6)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(book.title ?? "Без назви")
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(book.author ?? "Невідомий автор")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    Text(book.readingStatus.title)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(book.readingStatus.color.opacity(0.2))
                        .foregroundColor(book.readingStatus.color)
                        .cornerRadius(6)

                    if book.pageCount > 0 {
                        Text("Прогрес:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(book.progressString)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }
}
