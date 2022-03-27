//
//  CreatorCoreData+CoreDataProperties.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//
//

import Foundation
import CoreData


extension CreatorCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CreatorCoreData> {
        return NSFetchRequest<CreatorCoreData>(entityName: "CreatorCoreData")
    }

    @NSManaged public var role: String?
    @NSManaged public var name: String?
    @NSManaged public var comic: ComicCoreData?
    
    var wrappedRole: String {
        role ?? ""
    }
    
    var wrappedName: String {
        name ?? ""
    }

}

extension CreatorCoreData : Identifiable {

}
