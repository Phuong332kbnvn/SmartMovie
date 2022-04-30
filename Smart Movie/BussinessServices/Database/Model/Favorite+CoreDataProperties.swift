//
//  Favorite+CoreDataProperties.swift
//  Smart Movie
//
//  Created by Phuong on 30/04/2022.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var overview: String?
    @NSManaged public var time: Int64
    @NSManaged public var idUser: String?

}

extension Favorite : Identifiable {

}
