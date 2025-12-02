//
//  Book+CoreDataProperties.swift
//  RawDragAndDropProj
//

public import Foundation
public import CoreData

public typealias BookCoreDataPropertiesSet = NSSet

extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var pageCount: Int16
    @NSManaged public var currentPage: Int16
    @NSManaged public var status: String?
    @NSManaged public var sortIndex: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var desc: String?
    @NSManaged public var libraryIndex: Int64

}

extension Book: Identifiable {

}
