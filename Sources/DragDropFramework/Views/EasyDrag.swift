//
//  EasyDrag.swift
//  DragDropFramework
//

import SwiftUI

extension View {
    
    // MARK: - Single List Reorder
    
    /// Додає можливість Drag & Drop елементів в межах **одного списку**.
    ///
    /// Використовуйте цей модифікатор, якщо вам потрібно просто змінювати порядок елементів у `LazyVStack` або `List`.
    ///
    /// - Parameters:
    ///   - item: Поточний елемент (який рендериться у `ForEach`).
    ///   - items: Байндінг на весь масив елементів (для зміни порядку в реальному часі).
    ///   - draggedItem: Байндінг на змінну стану, яка зберігає елемент, що зараз перетягується.
    ///   - onDataChanged: (Опціонально) Замикання, яке викликається **після завершення** перестановки (наприклад, для збереження в БД).
    ///
    /// - Returns: View, модифікована для підтримки Drag & Drop.
    ///
    /// ## Приклад використання:
    /// ```swift
    /// ForEach(items) { item in
    ///     ItemView(item: item)
    ///         .easyReorderList(
    ///             item: item,
    ///             items: $items,
    ///             draggedItem: $draggedItem,
    ///             onDataChanged: { saveToCoreData() }
    ///         )
    /// }
    /// ```
    public func easyReorderList<T: Equatable & Identifiable>(
        item: T,
        items: Binding<[T]>,
        draggedItem: Binding<T?>,
        onDataChanged: (() -> Void)? = nil
    ) -> some View {
        EasyDraggableView(
            item: item,
            items: items,
            draggedItem: draggedItem,
            listId: nil,
            onDataChanged: onDataChanged,
            onMoveBetweenLists: nil,
            content: { self }
        )
    }
    
    // MARK: - Cross-List Reorder (Kanban)
    
    /// Додає можливість переміщення елементів **між різними списками** (Kanban-style).
    ///
    /// Використовуйте цей модифікатор, якщо у вас є кілька списків (наприклад, "To Do", "Done") і ви хочете перетягувати елементи між ними.
    ///
    /// - Parameters:
    ///   - item: Поточний елемент.
    ///   - items: Байндінг на масив поточного списку.
    ///   - draggedItem: Спільний байндінг на перетягуваний елемент (має бути спільним для всіх списків).
    ///   - listId: Унікальний ідентифікатор цього списку (наприклад, "reading").
    ///   - onDataChanged: Викликається після зміни порядку **всередині** цього списку.
    ///   - onMoveBetweenLists: Викликається, коли елемент **з іншого списку** перетягують сюди.
    ///
    /// ## Приклад:
    /// ```swift
    /// ForEach(readingBooks) { book in
    ///     BookRow(book: book)
    ///         .easyCrossListReorder(
    ///             item: book,
    ///             items: $readingBooks,
    ///             draggedItem: $draggedItem,
    ///             listId: "reading",
    ///             onMoveBetweenLists: { book, targetListId in
    ///                 viewModel.moveBook(book, to: targetListId)
    ///             }
    ///         )
    /// }
    /// ```
    public func easyCrossListReorder<T: Equatable & Identifiable>(
        item: T,
        items: Binding<[T]>,
        draggedItem: Binding<T?>,
        listId: String,
        onDataChanged: (() -> Void)? = nil,
        onMoveBetweenLists: @escaping (T, String) -> Void
    ) -> some View {
        EasyDraggableView(
            item: item,
            items: items,
            draggedItem: draggedItem,
            listId: listId,
            onDataChanged: onDataChanged,
            onMoveBetweenLists: onMoveBetweenLists,
            content: { self }
        )
    }
    
    // MARK: - Drop Destination (Empty List)
    
    /// Створює зону прийому ("Drop Zone") для **порожнього списку**.
    ///
    /// Використовуйте цей модифікатор на контейнері (наприклад, `VStack`), коли список порожній, щоб дозволити перетягування елементів у нього.
    /// Без цього модифікатора неможливо "покласти" перший елемент у порожній список.
    ///
    /// - Parameters:
    ///   - items: Байндінг на масив цього списку.
    ///   - draggedItem: Спільний стан перетягування.
    ///   - listId: ID цього списку.
    ///   - onMoveBetweenLists: Логіка переміщення елемента в цей список.
    ///
    /// ## Приклад:
    /// ```swift
    /// if books.isEmpty {
    ///     Text("Перетягніть сюди книгу")
    ///         .frame(maxWidth: .infinity, minHeight: 100)
    ///         .easyDropDestination(
    ///             items: $books,
    ///             draggedItem: $draggedBook,
    ///             listId: "reading",
    ///             onMoveBetweenLists: { book, listId in
    ///                 viewModel.moveBook(book, to: listId)
    ///             }
    ///         )
    /// }
    /// ```
    public func easyDropDestination<T: Equatable & Identifiable>(
        items: Binding<[T]>,
        draggedItem: Binding<T?>,
        listId: String,
        onMoveBetweenLists: @escaping (T, String) -> Void
    ) -> some View {
        self.onDrop(of: [.text], delegate: EmptyListDropDelegate(
            items: items,
            draggedItem: draggedItem,
            listId: listId,
            onMoveBetweenLists: onMoveBetweenLists
        ))
    }
    // MARK: - Configuration
    
    /// Налаштовує глобальну конфігурацію `EasyDrag` для цієї View та її дочірніх елементів.
    ///
    /// - Parameter config: Об'єкт конфігурації `EasyDragConfig`.
    public func easyDragConfig(_ config: EasyDragConfig) -> some View {
        self.environment(\.easyDragConfig, config)
    }
}

private struct EasyDraggableView<T: Equatable & Identifiable, Content: View>: View {
    
    let item: T
    @Binding var items: [T]
    @Binding var draggedItem: T?
    
    let listId: String?
    let onDataChanged: (() -> Void)?
    let onMoveBetweenLists: ((T, String) -> Void)?
    let content: () -> Content
    
    @Environment(\.easyDragConfig) private var config
    
    var body: some View {
        
        content()
            .opacity(isDragging ? config.draggedOpacity : 1.0)
            .scaleEffect(isDragging ? config.scaleEffect : 1.0)
            .animation(config.animation.value, value: isDragging)
            .onDrag {
                draggedItem = item
                triggerHapticIfNeeded()
                return NSItemProvider(object: "\(item.id)" as NSString)
            }
            .onDrop(of: [.text], delegate: EasyDropDelegate(
                item: item,
                items: $items,
                draggedItem: $draggedItem,
                config: config,
                listId: listId,
                onDataChanged: onDataChanged,
                onMoveBetweenLists: onMoveBetweenLists
            ))
    }
    
    private var isDragging: Bool {
        guard let dragged = draggedItem else { return false }
        return item.id == dragged.id
        
    }
    
    private func triggerHapticIfNeeded() {
        guard config.enableHaptics else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
