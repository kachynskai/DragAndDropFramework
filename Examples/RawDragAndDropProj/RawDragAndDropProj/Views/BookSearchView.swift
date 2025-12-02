//
//  BookSearchView.swift
//  RawDragAndDropProj
//

import SwiftUI

struct BookSearchView: View {
    @StateObject private var searchVM = BookSearchVM()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Введіть назву книги", text: $searchVM.searchText)
                            .submitLabel(.search)
                            .onSubmit {
                                searchVM.performSearch()
                            }
                        if !searchVM.searchText.isEmpty {
                            Button {
                                searchVM.searchText = ""
                                searchVM.books = []
                                searchVM.wasSeach = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .cornerRadius(10)
                    Button("Шукати") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        searchVM.performSearch()
                    }
                    .disabled(searchVM.searchText.isEmpty)
                }
                .padding()
                
                Divider()
                ZStack {
                    if searchVM.isLoading {
                        VStack {
                            Spacer()
                            ProgressView("Шукаємо...")
                            Spacer()
                        }
                    } else if searchVM.books.isEmpty {
                        EmptyStateView(hasSearched: searchVM.wasSeach, searchText: searchVM.searchText)
                    } else {
                        List(searchVM.books, id: \.id) { book in
                            BookSearchRow(book: book) {
                                searchVM.addBook(book)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Додати книгу")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Закрити")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

struct EmptyStateView: View {
    let hasSearched: Bool
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: hasSearched ? "magnifyingglass" : "book.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.3))
            
            Text(hasSearched ? "Нічого не знайдено за запитом\n\"\(searchText)\"" : "Введіть назву книги,\nяку хочете додати")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    BookSearchView()
}
