//
//  Utilities.swift
//  DragDropFramework
//
import Foundation

extension Array where Element: Equatable {
    
    /// Безпечно переміщує елемент з однієї позиції на іншу в масиві.
    ///
    /// Цей метод використовується для  сортування під час Drag & Drop.
    /// Він автоматично вираховує правильний зсув індексів.
    ///
    /// - Parameters:
    ///   - source: Елемент, який переміщуємо.
    ///   - destination: Елемент, на місце якого ставимо.
    mutating func moveItem(from source: Element, to destination: Element) {
        guard let fromIndex = self.firstIndex(of: source),
              let toIndex = self.firstIndex(of: destination) else { return }
        
        let moveToIndex = toIndex > fromIndex ? toIndex + 1 : toIndex
        
        if fromIndex != toIndex {
            self.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: moveToIndex)
        }
    }
}
