//
//  BookSearchRow.swift
//  RawDragAndDropProj
//

import SwiftUI

struct BookSearchRow: View {
    let book: GoogleBookItem
    var onAdd: () -> Void
    @State private var isAdded = false
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: book.volumeInfo.imageURL)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.2)
                    Image(systemName: "book.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                
            }
            .frame(width: 50, height: 75)
            .cornerRadius(5)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.volumeInfo.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(book.volumeInfo.authorsList)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if let pages = book.volumeInfo.pageCount {
                    if pages != 0 {
                        Text("\(pages) стор.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            Button {
                onAdd()
                withAnimation { isAdded = true }
            } label: {
                Image(systemName: isAdded ? "checkmark.circle.fill" : "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(isAdded ? .green : .blue)
            }
            .disabled(isAdded)
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
