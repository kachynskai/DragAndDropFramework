//
//  BookDetailView.swift
//  RawDragAndDropProj
//

import SwiftUI

struct BookDetailView: View {
    @StateObject private var detailsVM: BookDetailVM
    
    init(book: Book) {
        _detailsVM = StateObject(wrappedValue: BookDetailVM(book: book))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack {
                    if let urlStr = detailsVM.book.imageURL, let url = URL(string: urlStr) {
                        AsyncImage(url: url) { img in
                            img.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle().fill(Color.gray.opacity(0.2))
                        }
                        .frame(width: 100, height: 150)
                        .cornerRadius(12)
                    } else {
                        ZStack {
                            Color.gray.opacity(0.2)
                                .frame(width: 100, height: 150)
                                .cornerRadius(12)
                            Image(systemName: "book.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(detailsVM.book.title ?? "")
                            .font(.title2).bold()
                        Text(detailsVM.book.author ?? "")
                            .font(.headline).foregroundColor(.secondary)
                        
                        Text(detailsVM.book.readingStatus.title)
                            .padding(6)
                            .background(detailsVM.book.readingStatus.color.opacity(0.2))
                            .foregroundColor(detailsVM.book.readingStatus.color)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .padding()
                Divider()
                if let desc = detailsVM.book.desc, !desc.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Короткий опис:").font(.headline)
                        Text(desc)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                Divider()
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Ваш прогрес")
                            .font(.headline)
                        Spacer()
                        Text(detailsVM.percentageText)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.secondary)
                    }
                    Text(detailsVM.pageProgressText)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    
                    HStack(spacing: 15) {
                        Button {
                            if detailsVM.curPage > 0 {
                                detailsVM.curPage -= 1
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red.opacity(0.5))
                        }
                        .disabled(detailsVM.curPage <= 0)

                        Slider(value: $detailsVM.curPage, in: 0...Double(detailsVM.book.pageCount), step: 1)
                            .accentColor(.blue)
                        
                        Button {
                            if detailsVM.curPage < Double(detailsVM.book.pageCount) {
                                detailsVM.curPage += 1
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green.opacity(0.5))
                        }
                        .disabled(Int16(detailsVM.curPage) >= detailsVM.book.pageCount)
                    }
                    Button {
                        detailsVM.saveProgress()
                    } label: {
                        Text("Зберегти зміни")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.top, 5)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding(.top)
        }
        .navigationTitle("Деталі книги")
    }
}
