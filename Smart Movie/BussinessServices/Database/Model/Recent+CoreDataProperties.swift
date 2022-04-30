//
//  Recent+CoreDataProperties.swift
//  Smart Movie
//
//  Created by Phuong on 30/04/2022.
//
//

import Foundation
import CoreData


extension Recent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recent> {
        return NSFetchRequest<Recent>(entityName: "Recent")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var overview: String?
    @NSManaged public var time: Int64
    @NSManaged public var idUser: String?

}

extension Recent : Identifiable {

}
