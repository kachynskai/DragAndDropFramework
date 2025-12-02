//
//  DropDelegate.swift
//  DragDropFramework
//

import SwiftUI

/// Основний делегат, що керує логікою Drag & Drop.
///
/// Ця структура відповідає за:
/// - Визначення, чи відбувається перестановка в межах одного списку.
/// - Переміщення елементів між різними списками (Kanban).
/// - Запуск анімацій та тактильного відгуку (Haptics).
public struct EasyDropDelegate<T: Equatable & Identifiable>: DropDelegate {
    
    /// Елемент, над яким на даний момент знаходиться палець користувача.
    let item: T
    
    /// Посилання на масив даних, який ми модифікуємо.
    @Binding var items: [T]
    
    /// Глобальний стан: елемент, який зараз перетягують.
    @Binding var draggedItem: T?
    
    /// Конфігурація вигляду та поведінки (анімація, вібрація).
    let config: EasyDragConfig
    
    /// Ідентифікатор поточного списку (потрібен для Cross-List логіки).
    let listId: String?
    
    /// Замикання, що викликається при зміні порядку всередині списку
    var onDataChanged: (() -> Void)?
    
    /// Замикання, що викликається при переміщенні в інший список.
    var onMoveBetweenLists: ((T, String) -> Void)?
    
    public init(item: T, items: Binding<[T]>, draggedItem: Binding<T?>, config: EasyDragConfig, listId: String? = nil, onDataChanged: (() -> Void)? = nil, onMoveBetweenLists: ((T, String) -> Void)? = nil) {
        self.item = item
        self._items = items
        self._draggedItem = draggedItem
        self.config = config
        self.listId = listId
        self.onDataChanged = onDataChanged
        self.onMoveBetweenLists = onMoveBetweenLists
    }
    
    /// Визначає, як реагувати на drop
    public func dropUpdated(info: DropInfo) -> DropProposal {
        return DropProposal(operation: .move)
    }
    
    /// Викликається, коли користувач відпускає елемент.
    /// Тут ми фіксуємо зміни (зберігаємо дані) та очищаємо стан перетягування.
    public func performDrop(info: DropInfo) -> Bool {
        self.onDataChanged?()
        self.draggedItem = nil
        
        if config.enableHaptics {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        return true
    }
    
    /// Викликається, коли перетягуваний об'єкт "заходить" на територію іншого об'єкта.
    public func dropEntered(info: DropInfo) {
        guard let currentDragged = draggedItem else { return }
        if isInternalReorder(currentDragged) {
            handleInternalReorder(currentDragged)
        } else {
            handleCrossListMove(currentDragged)
        }
    }
    
    // MARK: - Helper Logic
    
    /// Перевіряє, чи елемент вже знаходиться у поточному списку.
    private func isInternalReorder(_ dragged: T) -> Bool {
        items.contains(dragged)
    }
    
    /// Обробляє перестановку елементів всередині одного списку.
    private func handleInternalReorder(_ dragged: T) {
        guard dragged != item else { return }
        
        if let from = items.firstIndex(of: dragged),
           let toIdx = items.firstIndex(of: item) {
            if from == toIdx { return }
            
            let animation = config.animation.value ?? .default
            
            withAnimation(animation) {
                items.moveItem(from: dragged, to: item)
            }
            
            if config.enableHaptics {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }
        }
        
    }
    
    /// Обробляє переміщення елемента з іншого списку в поточний.
    private func handleCrossListMove(_ dragged: T) {
        guard let listId = listId, let onMove = onMoveBetweenLists else { return }
        let animation = config.animation.value ?? .default
        
        withAnimation(animation) {
            onMove(dragged, listId)
        }
        
        if config.enableHaptics {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        
    }
    
}
