//
//  EmptyListDropDelegate.swift
//  DragDropFramework
//
import SwiftUI

/// Спеціалізований делегат для обробки перетягування у порожні списки.
///
/// Використовується, коли у списку немає елементів, але користувач хоче "кинути" туди об'єкт.
public struct EmptyListDropDelegate<T: Equatable & Identifiable>: DropDelegate {
    @Binding var items: [T]
    @Binding var draggedItem: T?
    let listId: String
    let onMoveBetweenLists: (T, String) -> Void
    
    /// Визначає, як реагувати на drop
    public func dropUpdated(info: DropInfo) -> DropProposal {
        return DropProposal(operation: .move)
    }
    
    /// Викликається, коли користувач відпускає елемент.
    public func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    /// Викликається при вході в зону порожнього списку.
    public func dropEntered(info: DropInfo) {
        guard let currentDragged = draggedItem else { return }
        
        withAnimation {
            onMoveBetweenLists(currentDragged, listId)
        }
    }
}
