//
//  ContactRouter.swift
//  Contacts
//
//  Created by Sushant Alone on 16/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import Foundation
import Alamofire

enum ContactRouter {
    case list
    case update(id : String, email : String, name : String , code : String, phnNumber : String)
    case add(email : String, name : String , code : String, phnNumber : String)
}

extension ContactRouter : APIRouter {
    var path: String {
        switch self {
        case .list:
            return "users/list"
        case .update:
            return "users/update"
        case .add:
            return "users/add"
        }
        
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .list:
            return .get
        default:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .list:
            return nil
        case .update(let id, let email,let name,let code, let phnNumber ):
            return ["emailId" : email, "name" : name, "countryCode" : code, "phoneNumber" : phnNumber, "id":id]
        case .add(let email,let name,let code, let phnNumber) :
            return ["emailId" : email, "name" : name, "countryCode" : code, "phoneNumber" : phnNumber]
        }
        
    }
    
    
}
