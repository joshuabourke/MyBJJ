//
//  Saved+CoreDataProperties.swift
//  MyBJJ
//
//  Created by Josh Bourke on 16/4/22.
//

import Foundation
import CoreData

extension SavedRolls {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRolls> {
        return NSFetchRequest<SavedRolls>(entityName: "SavedRolls")
    }
    @NSManaged public var sub: String?
    @NSManaged public var subType: String?
    @NSManaged public var subId: UUID
    @NSManaged public var subDate: Date
    @NSManaged public var winOrLoss: String?
}

extension SavedRolls: Identifiable {
    
}
