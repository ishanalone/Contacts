//
//  ListModel.swift
//  Contacts
//
//  Created by Sushant Alone on 16/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import Foundation
import CoreData

struct SuccessModel : Codable {
    let code : Int?
    let success : Bool?
}

struct ListModel : Codable {
    let code : Int?
    let contactList : [ContactList]?
}

struct ContactList : Codable {
    var email_id : String?
    var name : String?
    var country_code : String?
    let id : String?
    var phone_number : String?
    let updated_at : String?
    
    init() {
        email_id = ""
        name = ""
        country_code = ""
        phone_number = ""
        id = ""
        updated_at = ""
    }
}

extension ContactList{
    func getUpdateDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let createdDate = dateFormatter.date(from: updated_at!)
        return createdDate
    }
    
}

extension ContactList : Persistable{
    typealias ManagedObject = Contact
    
    init(managedObject: Contact) {
        id = managedObject.id
        name = managedObject.name
        email_id = managedObject.email
        country_code = managedObject.countryCode
        phone_number = managedObject.phoneNumber
        updated_at = ""
    }
    
    func managedObject() -> Contact? {
        if let context = self.context(){
            if let entity = entity(){
                let contact : Contact = NSManagedObject(entity: entity, insertInto: context) as! Contact
                contact.name = name
                contact.email = email_id
                contact.id = id
                contact.countryCode = country_code
                contact.phoneNumber = phone_number
                return contact
            }
            
        }
        return nil
    }
    
    func managedObject(_ object: Contact) -> Contact {
        object.name = name
        object.email = email_id
        object.id = id
        object.countryCode = country_code
        object.phoneNumber = phone_number
        return object
    }
    

    
    
}
