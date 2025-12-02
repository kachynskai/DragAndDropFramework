//
//  ShelfSectionView.swift
//  RawDragAndDropProj
//
import SwiftUI
import DragDropFramework

struct ShelfSectionView: View {
    let title: String
    @Binding var books: [Book]
    let color: Color
    
    @Binding var draggedBook: Book?
    let listId: String
    @ObservedObject var viewModel: ShelfVM
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                Spacer()
                Text("\(books.count)")
                    .font(.caption).bold()
                    .padding(6)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding()
            .background(Color.black.opacity(0.2))
            Divider()
            if books.isEmpty {
                Spacer()
                Text("Тут поки пусто")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .easyDropDestination(items: $books, draggedItem: $draggedBook, listId: listId, onMoveBetweenLists: { item, target in
                        viewModel.moveBook(book: item, toTargetListID: target)
                    })
                Spacer()
            } else {
                VStack(spacing: 0) {
                    ForEach(books) { book in
                        VStack(spacing: 0) {
                            NavigationLink(destination: BookDetailView(book: book)) {
                                ShelfRow(book: book)
                            }
                            .buttonStyle(.plain)
                            .easyCrossListReorder(item: book, items: $books, draggedItem: $draggedBook, listId: listId,
                                                  onDataChanged: {
                                viewModel.saveReorderedList()
                            },
                                                  onMoveBetweenLists: { item, targetListId in
                                viewModel.moveBook(book: item, toTargetListID: targetListId)
                            })
                        }
                        if book != books.last {
                            Divider()
                        }
                    }
                }
                
            }
        }
        .easyDragConfig(EasyDragConfig(
            draggedOpacity: 1.0,
            scaleEffect: 1.0,
            animation: .bouncy,
            enableHaptics: true
        ))
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct ShelfRow: View {
    @ObservedObject var book: Book
    
    var body: some View {
        HStack {
            Text(book.title ?? "Без назви")
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(.primary)
            
            Spacer()
            
            if book.readingStatus == .reading {
                Text(book.progressString)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.leading, 4)
            }
        }
        .padding()
        .contentShape(Rectangle())
    }
}
