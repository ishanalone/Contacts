//
//  Constant.swift
//  
//
//  Created by Sushant Alone on 04/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import Foundation
import UIKit

let activityBackgroundViewTag = 475647



struct Constants {
    static let activityBackgroundColor = UIColor(white: 0.2, alpha: 0.3)
    
}


enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
}



let defaultImage = #imageLiteral(resourceName: "Image")
