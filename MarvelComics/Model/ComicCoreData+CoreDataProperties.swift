//
//  ComicCoreData+CoreDataProperties.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//
//

import Foundation
import CoreData


extension ComicCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComicCoreData> {
        return NSFetchRequest<ComicCoreData>(entityName: "ComicCoreData")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var comicDescription: String?
    @NSManaged public var pageCount: Int16
    @NSManaged public var image: String?
    @NSManaged public var creators: NSSet?
    
    var wrappedTitle: String {
        title ?? ""
    }
    
    var wrappedPageCount: Int {
        Int(pageCount)
    }
    
    var wrappedImageURL: URL {
        URL(string: image ?? "")!
    }
    
    public var creatorsArray: [CreatorCoreData] {
        let set = creators as? Set<CreatorCoreData> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for creators
extension ComicCoreData {

    @objc(addCreatorsObject:)
    @NSManaged public func addToCreators(_ value: CreatorCoreData)

    @objc(removeCreatorsObject:)
    @NSManaged public func removeFromCreators(_ value: CreatorCoreData)

    @objc(addCreators:)
    @NSManaged public func addToCreators(_ values: NSSet)

    @objc(removeCreators:)
    @NSManaged public func removeFromCreators(_ values: NSSet)

}

extension ComicCoreData : Identifiable {

}
