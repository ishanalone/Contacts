//
//  ListModel.swift
//  Contacts
//
//  Created by Sushant Alone on 16/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import Foundation

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
    
    init() {
        email_id = ""
        name = ""
        country_code = ""
        phone_number = ""
        id = ""
    }
}
