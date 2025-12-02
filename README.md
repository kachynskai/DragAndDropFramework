# DragAndDropSwiftUIFramework — SwiftUI Drag & Drop Framework

Легкий, потужний та гнучкий SwiftUI фреймворк для реалізації **Drag & Drop** функціоналу.
Підтримує як просте сортування списків, так і складні Kanban-дошки з переміщенням між списками. 
## Особливості

- [x] **Easy Reorder:** Проста зміна порядку елементів у межах одного списку.
- [x] **Cross-List Drag:** Переміщення елементів між різними списками (Kanban).
- [x] **Drop Zone:** Підтримка перетягування у порожні списки.
- [x] **Customization:** Повна конфігурація анімації, прозорості та масштабу.
- [x] **Haptics:** Вбудована підтримка тактильного відгуку.
---

## Основні фічі

### ▸ 1. Drag & Drop всередині одного списку
Зміна порядку елементів у `LazyVStack`, кастомних списках.

```swift
ForEach(items) { item in
    Row(item: item)
        .easyReorderList(
            item: item,
            items: $items,
            draggedItem: $draggedItem
        )
}
```

### ▸ 2. Переміщення між різними списками (Kanban)

```swift
ForEach(todo) { card in
    CardRow(card: card)
        .easyCrossListReorder(
            item: card,
            items: $todo,
            draggedItem: $dragged,
            listId: "todo",
            onMoveBetweenLists: { card, newList in
                viewModel.move(card, to: newList)
            }
        )
}
```
### ▸ 3. Drop-зона для порожніх списків

```swift
VStack {
    Text("Перетягніть сюди")
        .easyDropDestination(
            items: $done,
            draggedItem: $dragged,
            listId: "done",
            onMoveBetweenLists: viewModel.move
        )
}
```
### ▸ 4. Глобальна конфігурація Drag & Drop

```swift
.easyDragConfig(EasyDragConfig(
    draggedOpacity: 0.3,
    scaleEffect: 1.1,
    animation: .bouncy,
    enableHaptics: true
))
```
## Встановлення

### Swift Package Manager (SPM)

1. У Xcode перейдіть до **File > Add Packages**.
2. Вставте посилання на репозиторій: https://github.com/kachynskai/DragAndDropFramework.git
3. Виберіть версію `Up to Next Major` (1.0.0).

### CocoaPods

Додайте наступний рядок у ваш `Podfile`:

```ruby
pod 'DragAndDropSwiftUIFramework', :git => '[https://github.com/kachynskai/DragAndDropFramework.git](https://github.com/kachynskai/DragAndDropFramework.git)'
