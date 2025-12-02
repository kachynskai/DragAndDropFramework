//
//  DragConfig.swift
//  DragDropFramework
//
import SwiftUI

/// Конфігурація для налаштування поведінки та зовнішнього вигляду Drag & Drop.
///
/// Використовуйте `EasyDragConfig` для зміни прозорості, масштабу, анімації та тактильного відгуку під час перетягування елементів.
///
/// ## Приклад використання:
/// ```swift
/// .easyDragConfig(EasyDragConfig(
///     draggedOpacity: 0.3,
///     scaleEffect: 1.1,
///     animation: .bouncy,
///     enableHaptics: true
/// ))
/// ```
public struct EasyDragConfig: Sendable {
    /// Прозорість елемента під час перетягування (значення від 0.0 до 1.0).
    /// - Default: 0.7
    public var draggedOpacity: Double
    
    /// Масштаб елемента під час перетягування (наприклад, 1.05 для збільшення).
    /// - Default: 1.0
    public var scaleEffect: CGFloat
    
    /// Тип анімації при переміщенні елементів у списку.
    /// - Default: .smooth
    public var animation: EasyDragAnimation
    
    /// Чи вмикати тактильний відгук (вібрацію) при діях Drag & Drop.
    /// - Default: true
    public var enableHaptics: Bool
    
    /// Стандартна конфігурація за замовчуванням.
    public static let `default` = EasyDragConfig(
        draggedOpacity: 0.7,
        scaleEffect: 1.0,
        animation: .smooth,
        enableHaptics: true
    )
    
    /// Ініціалізує нову конфігурацію з заданими параметрами.
    /// - Parameters:
    ///   - draggedOpacity: Прозорість перетягуваного елемента.
    ///   - scaleEffect: Масштаб перетягуваного елемента.
    ///   - animation: Анімація переміщення інших елементів.
    ///   - enableHaptics: Увімкнення вібрації.
    public init(
        draggedOpacity: Double = 0.5,
        scaleEffect: CGFloat = 1.0,
        animation: EasyDragAnimation = .none,
        enableHaptics: Bool = true
    ) {
        self.draggedOpacity = draggedOpacity
        self.scaleEffect = scaleEffect
        self.animation = animation
        self.enableHaptics = enableHaptics
    }
}

/// Типи анімацій для переміщення елементів списку.
public enum EasyDragAnimation: Sendable {
    /// Плавна стандартна анімація.
    case smooth
    /// Анімація з ефектом пружини (більш жива).
    case bouncy
    /// Жорстка пружина.
    case spring
    /// Ваша власна кастомна анімація.
    case custom(Animation)
    /// Без анімації.
    case none
    
    var value: Animation? {
        switch self {
        case .smooth:
            return .easeInOut(duration: 0.3)
        case .bouncy:
            return .spring(response: 0.3, dampingFraction: 0.6)
        case .spring:
            return .spring()
        case .custom(let anim):
            return anim
        case .none:
            return nil
        }
    }
}

private struct EasyDragConfigKey: EnvironmentKey {
    static let defaultValue = EasyDragConfig.default
}

extension EnvironmentValues {
    /// Доступ до поточної конфігурації EasyDrag у середовищі.
    public var easyDragConfig: EasyDragConfig {
        get { self[EasyDragConfigKey.self] }
        set { self[EasyDragConfigKey.self] = newValue }
    }
}
