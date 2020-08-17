//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by Sushant Alone on 17/08/20.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var lastUsed: Date?

}
