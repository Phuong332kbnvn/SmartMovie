//
//  Favorite+CoreDataProperties.swift
//  Smart Movie
//
//  Created by Phuong on 18/03/2022.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var id: Int64

}

extension Favorite : Identifiable {

}
